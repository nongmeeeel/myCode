import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/service/MemberController.dart';

import '../../service/ChatController.dart';
import 'ChatDetailView.dart';

class ChatRoomsView extends GetView<ChatController> {
  MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateChatRoomDialog,
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingChatList.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(child: Text('오류: ${controller.error.value}'));
        }

        if (controller.chatList.isEmpty) {
          return Center(child: Text('채팅방이 없습니다'));
        }

        return ListView.builder(
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            final chat = controller.chatList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/minji.jpg'),
                radius: 25.0, // 프로필 사진의 크기 설정
              ),
              title: Text(chat.lastContent ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${chat.memberName} • ${chat.memberGender} • ${chat.memberBirthDate}'),
                ],
              ),
              trailing: chat.lastReadYn == 'N' &&
                      chat.lastSenderId != _memberController.member.value!.id
                  ? Badge(
                      label: Text('New'),
                      child: Icon(Icons.chat),
                    )
                  : null,
              onTap: () => Get.to(() => ChatDetailView(chatRoom: chat)),
            );
          },
        );
      }),
    );
  }

  void _showCreateChatRoomDialog() {
    final titleController = TextEditingController();
    final memberController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('새 채팅방 생성'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '채팅방 제목'),
            ),
            TextField(
              controller: memberController,
              decoration: InputDecoration(labelText: '초대할 멤버 ID (쉼표로 구분)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  memberController.text.isNotEmpty) {
                final memberIds = memberController.text
                    .split(',')
                    .map((id) => int.tryParse(id.trim()))
                    .where((id) => id != null)
                    .map((id) => id!)
                    .toList();

                controller.createChatRoom(
                  titleController.text,
                  'GROUP',
                  memberIds,
                );
              }
            },
            child: Text('생성'),
          ),
        ],
      ),
    );
  }
}

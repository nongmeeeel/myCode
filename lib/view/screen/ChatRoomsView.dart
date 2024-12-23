import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../service/ChatController.dart';
import 'ChatDetailView.dart';

class ChatRoomsView extends GetView<ChatController> {
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
            final chatRoom = controller.chatList[index];
            return ListTile(
              title: Text(chatRoom.title),
              subtitle: Text(chatRoom.lastMessage ?? ''),
              trailing: Text('참여자: ${chatRoom.chatMembers.length}명'),
              onTap: () => Get.to(() => ChatDetailView(chatRoom: chatRoom)),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../service/ChatController.dart';
import 'ChatDetailView.dart';

class ChatRoomsView extends StatelessWidget {
  final ChatController _chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    _chatController.fetchUserChatRooms();
    final member = Get.arguments;

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
        if (_chatController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_chatController.error.value != null) {
          return Center(
            child: Text('오류: ${_chatController.error.value}'),
          );
        }

        return ListView.builder(
          itemCount: _chatController.chatList.length,
          itemBuilder: (context, index) {
            final chatRoom = _chatController.chatList[index];
            return ListTile(
              title: Text(chatRoom.title),
              subtitle: Text(chatRoom.lastMessage ?? '메시지 없음'),
              trailing: Text('${chatRoom.participantCount}명'),
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

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
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
              decoration: InputDecoration(
                  labelText: '초대할 멤버 ID (쉼표로 구분)'),
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
              final memberIds = memberController.text
                  .split(',')
                  .map((id) => int.parse(id.trim()))
                  .toList();
              _chatController.createChatRoom(
                titleController.text,
                'GROUP',
                memberIds,
              );
              Get.back();
            },
            child: Text('생성'),
          ),
        ],
      ),
    );
  }
}
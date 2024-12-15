import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../model/local/Chat.dart';
import '../../model/local/ChatMessage .dart';
import '../../service/ChatController.dart';

class ChatDetailView extends StatelessWidget {
  final Chat chatRoom;
  final ChatController _chatController = Get.find();
  final TextEditingController _messageController = TextEditingController();
  final int currentUserId = 1; // 현재 사용자 ID (예시)

  ChatDetailView({required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    _chatController.fetchChatMessages(chatRoom.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: _chatController.chatMessageList.length,
                itemBuilder: (context, index) {
                  final message = _chatController.chatMessageList[index];
                  final isCurrentUser = message.senderId == currentUserId;

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message.content),
                    ),
                  );
                },
              );
            }),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '메시지 입력...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final message = ChatMessage(
        chatId: chatRoom.id,
        senderId: currentUserId,
        content: _messageController.text,
        type: 'TEXT',
        sendAt: DateTime.now().toString(),
        readStatus: 'UNREAD', id: null,
      );

      _chatController.sendMessage(message);
      _messageController.clear();
    }
  }
}
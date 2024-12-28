import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/ChatMessage.dart';
import 'package:mycode/model/local/response/ChatWithMember.dart';

import '../../model/local/Chat.dart';
import '../../service/ChatController.dart';
import '../../service/MemberController.dart';

class ChatDetailView extends StatelessWidget {
  final ChatWithMember chatRoom;
  final ChatController chatController = Get.find<ChatController>();
  final MemberController memberController = Get.find<MemberController>();
  final ScrollController _scrollController = ScrollController();

  ChatDetailView({required this.chatRoom}) {
    chatController.enterChatRoom(chatRoom.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            chatController.leaveChatRoom();
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.isLoadingMessages.value) {
                return Center(child: CircularProgressIndicator());
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: chatController.chatMessageList.length,
                itemBuilder: (context, index) {
                  final message = chatController.chatMessageList[index];
                  final isCurrentUser =
                      message.senderId == memberController.member.value?.id;

                  return MessageBubble(
                    message: message,
                    isCurrentUser: isCurrentUser,
                  );
                },
              );
            }),
          ),
          MessageInput(
            controller: chatController.messageController,
            onSend: () {
              if (chatController.messageController.text.trim().isNotEmpty) {
                final message = ChatMessage(
                  chatId: chatRoom.id,
                  senderId: memberController.member.value!.id,
                  content: chatController.messageController.text,
                  type: 'TEXT',
                  sendAt: DateTime.now().toIso8601String(),
                  readStatus: 'N',
                  id: null,
                );

                chatController.sendMessage(message);
                chatController.messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

// 메시지 버블 위젯
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const MessageBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.content),
      ),
    );
  }
}

// 메시지 입력 위젯
class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
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
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}

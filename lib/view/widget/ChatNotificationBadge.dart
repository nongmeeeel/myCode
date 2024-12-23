import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/ChatController.dart';

class ChatNotificationBadge extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unreadCount = chatController.chatMessageList.length;
      return unreadCount > 0
          ? Badge(
              label: Text('$unreadCount'),
              child: Icon(Icons.chat),
            )
          : Icon(Icons.chat);
    });
  }
}

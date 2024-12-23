class ChatNotification {
  final int chatRoomId;
  final String chatRoomTitle;
  final String lastMessage;
  final String senderName;
  final DateTime timestamp;
  final NotificationType type;  // 알림 타입 (새 메시지, 멘션 등)

  ChatNotification({
    required this.chatRoomId,
    required this.chatRoomTitle,
    required this.lastMessage,
    required this.senderName,
    required this.timestamp,
    required this.type,
  });

  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    return ChatNotification(
      chatRoomId: json['chatRoomId'],
      chatRoomTitle: json['chatRoomTitle'],
      lastMessage: json['lastMessage'],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values[json['type']],
    );
  }
}

enum NotificationType { NEW_MESSAGE, MENTION, INVITE } 
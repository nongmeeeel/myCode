class ChatMessage {
  final int? id;
  final int chatId;
  final int senderId;
  final String content;
  final String type;
  final String sendAt; // LocalDateTime -> String으로 처리
  final String readStatus;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.sendAt,
    required this.readStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'sendAt': sendAt,
      'readStatus': readStatus,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      type: json['type'],
      sendAt: json['sendAt'], // LocalDateTime을 String으로 변환
      readStatus: json['readStatus'],
    );
  }
}
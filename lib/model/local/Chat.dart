class Chat {
  final int id;
  final String title;
  final String type;
  final int participantCount;
  final String? lastMessage;
  final String? lastMessageTime; // LocalDateTime -> String으로 처리

  Chat({
    required this.id,
    required this.title,
    required this.type,
    required this.participantCount,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'participantCount': participantCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      participantCount: json['participantCount'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'], // LocalDateTime을 String으로 변환
    );
  }
}
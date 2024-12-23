class ChatMember {
  final int id;
  final int chatId;
  final int memberId;
  final String joinedAt;
  final String role;

  ChatMember({
    required this.id,
    required this.chatId,
    required this.memberId,
    required this.joinedAt,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'memberId': memberId,
      'joinedAt': joinedAt,
      'role': role,
    };
  }

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      id: json['id'],
      chatId: json['chatId'],
      memberId: json['memberId'],
      joinedAt: json['joinedAt'],
      role: json['role'],
    );
  }
}

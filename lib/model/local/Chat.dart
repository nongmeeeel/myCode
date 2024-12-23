import 'package:mycode/model/local/ChatMember.dart';

class Chat {
  final int id;
  final String title;
  final String type;
  final String? lastMessage;
  final String? lastMessageTime;
  final List<ChatMember> chatMembers;  // ChatMember 리스트로 변경

  Chat({
    required this.id,
    required this.title,
    required this.type,
    this.lastMessage,
    this.lastMessageTime,
    required this.chatMembers,
  });

  // participants getter 추가
  List<int> get participants => 
      chatMembers.map((member) => member.memberId).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'chatMembers': chatMembers.map((m) => m.toJson()).toList(),
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      chatMembers: (json['chatMembers'] as List)
          .map((m) => ChatMember.fromJson(m))
          .toList(),
    );
  }
}
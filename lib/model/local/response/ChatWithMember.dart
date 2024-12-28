class ChatWithMember {
  final int id;
  final String title;
  final String type;
  final int? memberId;
  final String? memberName;
  final String? memberGender;
  final String? memberBirthDate;

  String? lastMessage;
  int? lastSenderId;
  String? lastContent;
  String? lastReadYn;

  ChatWithMember({
    required this.id,
    required this.title,
    required this.type,
    this.memberId,
    this.memberName,
    this.memberGender,
    this.memberBirthDate,
    this.lastMessage,
    this.lastSenderId,
    this.lastContent,
    this.lastReadYn,
  });

  factory ChatWithMember.fromJson(Map<String, dynamic> json) {
    return ChatWithMember(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      memberId: json['memberId'],
      memberName: json['memberName'],
      memberGender: json['memberGender'],
      memberBirthDate: json['memberBirthDate'],
      lastMessage: json['lastMessage'],
      lastSenderId: json['lastSenderId'],
      lastContent: json['lastContent'],
      lastReadYn: json['lastReadYn'],
    );
  }
}

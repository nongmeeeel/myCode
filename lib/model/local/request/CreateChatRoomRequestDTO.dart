class CreateChatRoomRequestDTO {
  final String title;
  final String type;
  final List<int> chatMemberIdList;

  CreateChatRoomRequestDTO({
    required this.title,
    required this.type,
    required this.chatMemberIdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'chatMemberIdList': chatMemberIdList,
    };
  }
}
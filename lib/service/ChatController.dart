import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/ChatMessage.dart';
import 'package:mycode/service/MemberController.dart';
import '../model/local/Chat.dart';
import '../model/local/Member.dart';
import '../model/local/request/CreateChatRoomRequestDTO.dart';
import '../repository/local/ChatRepository.dart';
import '../view/screen/ChatDetailView.dart';
import '../common/FunctionUtil.dart';
import '../model/local/ChatNotification.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository = ChatRepository();
  final TextEditingController messageController = TextEditingController();
  StreamSubscription? _subscription;

  final RxList<Chat> chatList = <Chat>[].obs;
  final RxList<ChatMessage> chatMessageList = <ChatMessage>[].obs;
  final RxBool isLoadingChatList = false.obs;
  final RxBool isLoadingMessages = false.obs;
  final Rx<String?> error = Rx<String?>(null);

  @override
  void onClose() {
    _subscription?.cancel();
    messageController.dispose();
    _chatRepository.streamController.close();
    super.onClose();
  }

  Future<void> fetchUserChatRooms() async {
    isLoadingChatList.value = true;
    final result = await _chatRepository.getUserChatRooms();
    if (result != null) {
      chatList.value = result;
    } else {
      error.value = '채팅방 목록을 불러오는데 실패했습니다';
    }
    isLoadingChatList.value = false;
  }

  void enterChatRoom(int chatRoomId) {
    print('@@@@@@ 채팅방 입장: $chatRoomId @@@@@@');
    fetchChatMessages(chatRoomId);
    _subscription?.cancel();

    _chatRepository.subscribeToChatRoom(chatRoomId);
    _subscription = _chatRepository.getChatStream(chatRoomId).listen(
      (message) {
        if (!chatMessageList.any((m) => m.id == message.id)) {
          chatMessageList.add(message);
        }
      },
      onError: (error) => print('@@@@@@ 스트림 에러: $error @@@@@@'),
    );
  }

  Future<void> fetchChatMessages(int chatId) async {
    isLoadingMessages.value = true;
    final result = await _chatRepository.getChatMessages(chatId);
    if (result != null) {
      chatMessageList.value = result;
    } else {
      error.value = '메시지를 불러오는데 실패했습니다';
    }
    isLoadingMessages.value = false;
  }

  void sendMessage(ChatMessage message) {
    _chatRepository.sendMessage(message);
  }

  Future<void> createDirectChatRoom(Member targetMember) async {
    final request = CreateChatRoomRequestDTO(
      title: '${targetMember.name}님과의 1:1 채팅',
      type: 'PRIVATE',
      chatMemberIdList: [targetMember.id],
    );

    final result = await _chatRepository.createChatRoom(request);
    if (result != null) {
      chatList.add(result);
      Get.to(() => ChatDetailView(chatRoom: result));
    } else {
      error.value = '채팅방 생성에 실패했습니다';
    }
  }

  void leaveChatRoom() {
    _subscription?.cancel();
    chatMessageList.clear();
    messageController.clear();
  }

  Future<void> createChatRoom(
      String title, String type, List<int> memberIds) async {
    final currentMember = Get.find<MemberController>().member.value;
    if (currentMember == null) return;

    final request = CreateChatRoomRequestDTO(
      title: title,
      type: type,
      chatMemberIdList: [...memberIds, currentMember.id],
    );

    final result = await _chatRepository.createChatRoom(request);
    if (result != null) {
      chatList.add(result);
      Get.back();
    } else {
      error.value = '채팅방 생성에 실패했습니다';
    }
  }
}

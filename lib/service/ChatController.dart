import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/local/Chat.dart';
import '../model/local/ChatMessage .dart';
import '../model/local/Member.dart';
import '../model/local/request/CreateChatRoomRequestDTO.dart';
import '../repository/local/ChatRepository.dart';
import '../view/screen/ChatDetailView.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();

  final RxList<Chat> chatList = <Chat>[].obs;
  final RxList<ChatMessage> chatMessageList = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> error = Rx<String?>(null);

  Future<void> fetchUserChatRooms() async {
    try {
      isLoading.value = true;
      chatList.value = await _repository.getUserChatRooms();
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChatMessages(int chatId) async {
    try {
      isLoading.value = true;
      chatMessageList.value = await _repository.getChatMessages(chatId);
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Chat?> createChatRoom(
      String title, String type, List<int> memberIds) async {
    try {
      final request = CreateChatRoomRequestDTO(
        title: title,
        type: type,
        chatMemberIdList: memberIds,
      );
      final chatRoom = await _repository.createChatRoom(request);
      chatList.add(chatRoom);
      return chatRoom;
    } catch (e) {
      error.value = e.toString();
      return null;
    }
  }

  Future<void> markMessagesAsRead(int chatId, int memberId) async {
    try {
      await _repository.markMessagesAsRead(chatId, memberId);
      // 메시지 상태 갱신 로직 추가 가능
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<ChatMessage?> sendMessage(ChatMessage message) async {
    try {
      final sentMessage = await _repository.sendMessage(message);
      chatMessageList.add(sentMessage);
      return sentMessage;
    } catch (e) {
      error.value = e.toString();
      return null;
    }
  }

  Future<void> createDirectChatRoom(Member member) async {
    try {
      final CreateChatRoomRequestDTO request = CreateChatRoomRequestDTO(
          title: '${member.name}님과의 1:1 채팅',
          type: 'PRIVATE',
          chatMemberIdList: [member.id]
      );

      final chatRoom = await _repository.createChatRoom(request);

      // 생성된 채팅방으로 바로 이동
      Get.to(() => ChatDetailView(chatRoom: chatRoom));
    } catch (e) {
      error.value = e.toString();
    }
  }
}
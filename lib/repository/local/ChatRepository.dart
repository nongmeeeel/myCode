import 'package:dio/dio.dart';
import 'package:mycode/common/FunctionUtil.dart';
import 'package:mycode/model/local/ChatMessage.dart';
import 'dart:convert';
import '../../common/BaseDio.dart';
import '../../common/WebSocketManager.dart';
import '../../model/local/Chat.dart';
import '../../model/local/request/CreateChatRoomRequestDTO.dart';
import '../../model/local/ChatNotification.dart';
import 'dart:async';
import 'package:get/get.dart';

class ChatRepository {
  final Dio _dio = BaseDio('/chat').dio;
  final WebSocketManager _wsManager = WebSocketManager();
  final StreamController<ChatMessage> streamController =
      StreamController<ChatMessage>.broadcast();

  // @@@@@@@@@@ HTTP API 메서드들 @@@@@@@@@@
  Future<List<Chat>?> getUserChatRooms() async {
    try {
      final response = await _dio.get('/rooms');
      return (response.data as List)
          .map((json) => Chat.fromJson(json))
          .toList();
    } catch (e) {
      handleException(e);
      return null;
    }
  }

  Future<List<ChatMessage>?> getChatMessages(int chatId) async {
    try {
      final response = await _dio.get('/messages/$chatId');
      return (response.data as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      handleException(e);
      return null;
    }
  }

  Future<Chat?> createChatRoom(CreateChatRoomRequestDTO request) async {
    try {
      final response = await _dio.post('/room', data: request.toJson());
      return Chat.fromJson(response.data);
    } catch (e) {
      handleException(e);
      return null;
    }
  }

  Future<void> markMessagesAsRead(int chatId, int memberId) async {
    try {
      await _dio.post('/messages/read', queryParameters: {
        'chatId': chatId,
        'memberId': memberId,
      });
    } catch (e) {
      handleException(e);
    }
  }

  // @@@@@@@@@@ WebSocket 메서드들 @@@@@@@@@@
  void sendMessage(ChatMessage message) {
    print(
        '@@@@@@ 메시지 전송 시도: chatId=${message.chatId}, content=${message.content} @@@@@@');
    _wsManager.sendMessage(
      '/app/chat/${message.chatId}/send',
      jsonEncode(message.toJson()),
    );
  }

  // @@@@@@@@@@ WebSocket 구독 메서드 @@@@@@@@@@
  void subscribeToChatRoom(int chatRoomId) {
    print('@@@@@@ 채팅방 구독 시작: $chatRoomId @@@@@@');

    _wsManager.subscribe(
      '/topic/chat/${chatRoomId}',
      (frame) {
        print('@@@@@@ 웹소켓 메시지 수신: ${frame.body} @@@@@@');
        if (frame.body != null) {
          try {
            final message = ChatMessage.fromJson(jsonDecode(frame.body!));
            print(
                '@@@@@@ 파싱된 메시지: senderId=${message.senderId}, content=${message.content} @@@@@@');
            streamController.add(message);
          } catch (e) {
            print('@@@@@@ 메시지 파싱 에러: $e @@@@@@');
          }
        }
      },
    );
  }

  Stream<ChatMessage> getChatStream(int chatRoomId) {
    return streamController.stream
        .where((message) => message.chatId == chatRoomId);
  }
}

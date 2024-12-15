import 'package:dio/dio.dart';

import '../../common/BaseDio.dart';
import '../../model/local/Chat.dart';
import '../../model/local/ChatMessage .dart';
import '../../model/local/request/CreateChatRoomRequestDTO.dart';

class ChatRepository {
  final Dio _dio = BaseDio('/chat').dio;

  Future<List<Chat>> getUserChatRooms() async {
    try {
      final response = await _dio.get('/rooms');
      return (response.data as List)
          .map((json) => Chat.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load chat rooms: $e');
    }
  }

  Future<List<ChatMessage>> getChatMessages(int chatId) async {
    try {
      final response = await _dio.get('/messages/$chatId');
      return (response.data as List)
          .map((json) => ChatMessage.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load chat messages: $e');
    }
  }

  Future<Chat> createChatRoom(CreateChatRoomRequestDTO request) async {
    try {
      final response = await _dio.post('/room', data: request.toJson());
      return Chat.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  Future<void> markMessagesAsRead(int chatId, int memberId) async {
    try {
      await _dio.post('/messages/read', queryParameters: {
        'chatId': chatId,
        'memberId': memberId,
      });
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  Future<ChatMessage> sendMessage(ChatMessage message) async {
    try {
      final response = await _dio.post('/send', data: message.toJson());
      return ChatMessage.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
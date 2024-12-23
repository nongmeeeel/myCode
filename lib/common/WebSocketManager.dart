import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';
import '../common/auth/TokenUtil.dart';
import 'dart:convert';
import 'package:mycode/model/local/ChatMessage.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  StompClient? _stompClient;
  bool get isConnected => _stompClient?.connected ?? false;

  Future<void> initialize() async {
    if (_stompClient?.connected ?? false) return;

    final accessToken = await TokenUtil.getAccessToken();
    print('@@@@@@ 웹소켓 초기화 시작: 토큰=$accessToken @@@@@@');

    final completer = Completer<void>();

    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/ws',
        onConnect: (frame) {
          print('@@@@@@ 웹소켓 연결 성공: ${frame.body} @@@@@@');
          completer.complete();
        },
        onDisconnect: (frame) {
          print('Disconnected from WebSocket');
          _reconnect();
        },
        onWebSocketError: (error) {
          print('@@@@@@ 웹소켓 에러: $error @@@@@@');
          completer.completeError(error);
          _reconnect();
        },
        webSocketConnectHeaders: {
          'Access-Token': accessToken,
        },
        reconnectDelay: Duration(milliseconds: 5000),
      ),
    );

    _stompClient?.activate();
    await completer.future;
  }

  Future<void> _reconnect() async {
    print('@@@@@@ 웹소켓 재연결 시도 시작 @@@@@@');
    await Future.delayed(Duration(seconds: 5));
    try {
      await initialize();
      print('@@@@@@ 웹소켓 재연결 성공 @@@@@@');
    } catch (e) {
      print('@@@@@@ 웹소켓 재연결 실패: $e @@@@@@');
      _reconnect();
    }
  }

  StompClient get client {
    if (!isConnected) {
      initialize();
    }
    return _stompClient!;
  }

  Future<void> sendMessage(String destination, String message) async {
    try {
      if (!isConnected) {
        print('@@@@@@ 웹소켓 연결 끊김: 재연결 시도 @@@@@@');
        await initialize();
      }
      _stompClient?.send(
        destination: destination,
        body: message,
      );
      print('@@@@@@ 웹소켓 메시지 전송 성공: $destination @@@@@@');
    } catch (e) {
      print('@@@@@@ 웹소켓 메시지 전송 실패: $e @@@@@@');
      rethrow;
    }
  }

  Future<void> subscribe(
      String destination, Function(StompFrame) callback) async {
    try {
      if (!isConnected) {
        print('@@@@@@ 웹소켓 연결 끊김: 구독 전 재연결 시도 @@@@@@');
        await initialize();
      }
      _stompClient?.subscribe(
        destination: destination,
        callback: callback,
      );
      print('@@@@@@ 웹소켓 구독 성공: $destination @@@@@@');
    } catch (e) {
      print('@@@@@@ 웹소켓 구독 실패: $e @@@@@@');
      rethrow;
    }
  }
}

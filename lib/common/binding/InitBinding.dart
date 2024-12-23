import 'package:get/get.dart';
import '../WebSocketManager.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() async {
    // 웹소켓 매니저 초기화
    final wsManager = WebSocketManager();
    await wsManager.initialize();
    
    // 다른 초기 바인딩들...
  }
} 
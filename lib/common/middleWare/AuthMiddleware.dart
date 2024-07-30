import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../../service/AuthController.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    // 비동기 처리가 필요할 경우, 미들웨어의 redirect에서 비동기 처리를 지원하지 않으므로, 동기적으로 처리해야 함
    if (authController.isLogin.value) {
      return null; // 인증된 경우, 원래 라우트로 이동
    } else {
      print('---- AuthAPI 요청 ----');
      return RouteSettings(name: '/login'); // 인증되지 않은 경우 로그인 페이지로 리다이렉트
    }
  }
}
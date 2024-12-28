import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/MemberController.dart';


class AuthMiddleware extends GetMiddleware {
  final MemberController m = Get.find<MemberController>();

  @override
  RouteSettings? redirect(String? route) {
    // 로그인 상태 체크
    if (!m.isLogin()) {
      // 로그인 상태가 아니면 로그인 페이지로 리디렉션
      return const RouteSettings(name: '/login');
    }

    // isMember가 false이면 회원가입 페이지로 리디렉션
    if (!m.isMember()) {
      return const RouteSettings(name: '/sign'); // 회원가입 페이지로 설정
    }

    // 조건을 충족하면 null 반환하여 원래 요청한 라우트로 이동
    return null;
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/service/MemberController.dart';

class LoginScreen extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.network(kakaoLoginController.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
              Text("로그인 페이지"),
              ElevatedButton(
                onPressed: () => memberController.login(),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
  }
}
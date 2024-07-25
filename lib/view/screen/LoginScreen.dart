import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/service/AuthController.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
      User? kakaoUser = authController.kakaoUser.value;

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.network(kakaoLoginController.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
              Text(
                '${kakaoUser?.kakaoAccount?.profile?.nickname}',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                onPressed: () async {
                  bool isLogin = await authController.kakaoLogin();
                  if (isLogin) {
                    Get.offNamed('/');
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () => authController.kakaoLogout(),
                child: Text('Logout'),
              )
            ],
          ),
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao_user;
import 'package:mycode/view/HomeScreen.dart';
import 'package:mycode/view/LoginScreen.dart';

import '../model/local/Code.dart';
import '../model/local/User.dart';
import '../service/AuthController.dart';
import '../service/CodeController.dart';
import '../service/TownController.dart';
import '../service/UserController.dart';
import 'SignScreen.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final UserController userController = Get.put(UserController());

    userController.fetchUserList();
    userController.fetchUser();

    return Obx(() {
      var kakaoUser = authController.kakaoUser.value;
      List<User> userList = userController.userList.value;

      if(kakaoUser == null) {
        return LoginScreen();

      } else {
        if(userList.isEmpty) {
          return SignScreen();
        }

        CodeController codeController = Get.put(CodeController());
        Get.put(TownController());
        codeController.fetchAllCodeList();
        return Obx(() {
          List<CodeType> allCodeList = codeController.allCodeList.value;
          return HomeScreen();
        });
      }
    });
  }
}
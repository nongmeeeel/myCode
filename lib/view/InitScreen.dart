import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao_user;
import 'package:mycode/view/HomeScreen.dart';
import 'package:mycode/view/LoginScreen.dart';
import 'package:mycode/view/SplashScreen.dart';

import '../model/local/Code.dart';
import '../model/local/Member.dart';
import '../service/CodeController.dart';
import '../service/TownController.dart';
import '../service/MemberController.dart';
import 'SignScreen.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MemberController memberController = Get.find<MemberController>();
    final CodeController codeController = Get.find<CodeController>();

    return Obx(() {

      var isInit = memberController.isInit.value;
      var isLogin = memberController.isLogin.value;
      var isMember = memberController.isMember.value;


      if(isInit) {
        if(isLogin) {
          if(isMember) {
            memberController.fetchMember();
            return Obx((){
              Member? member = memberController.member.value;
              if(member != null) {
                // memberController.selectMemberListByMapInfo();
                codeController.fetchAllCodeList();
                return HomeScreen();
              } else {
                return SplashScreen();
              }
            });

          } else {
            return SignScreen();
          }

        } else {
          return LoginScreen();
        }
      }
      return SplashScreen();
    });
  }
}
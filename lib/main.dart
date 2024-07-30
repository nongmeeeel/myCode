import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/service/AuthController.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/UserController.dart';
import 'package:mycode/service/TownController.dart';
import 'package:mycode/view/HomeScreen.dart';
import 'package:mycode/view/LoadingScreen.dart';
import 'package:mycode/view/LoginScreen.dart';
import 'package:mycode/view/screen/MyMapScreen.dart';
import 'package:mycode/view/screen/TownSearchScreen.dart';

import 'common/middleWare/AuthMiddleware.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  await _initializeControllers();
  runApp(MyCode());
}

//KAKAO로그인, NAVER맵 세팅 초기화
Future<void> _initialize() async {
  KakaoSdk.init(nativeAppKey: '2ab3cf1d10a4a98cdf9d505671df64f1');
  await NaverMapSdk.instance.initialize(
      clientId: 'xzbx4hfeqo', // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );
}

// 컨트롤러 초기화 함수
Future<void> _initializeControllers() async {
  final authController = Get.put(AuthController());
  await authController.loginCheck();
}


class MyCode extends StatelessWidget {
  MyCode({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "마이코드",
      initialRoute: '/loading',
      getPages:  [
        GetPage(name: '/loading', page: () => LoadingScreen(), transition: Transition.leftToRight),
        GetPage(name: '/', page: () => HomeScreen(), transition: Transition.leftToRight,),
        GetPage(name: '/login', page: () => LoginScreen(), transition: Transition.leftToRight),
        GetPage(name: '/home/map', page: () => MyMapScreen(), transition: Transition.downToUp,),
        GetPage(name: '/home/map/townsearch', page: () => TownSearchScreen(), transition: Transition.rightToLeft)
      ],
    );
  }
}

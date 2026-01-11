import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/service/ChatController.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:mycode/service/TownController.dart';
import 'package:mycode/view/HomeScreen.dart';
import 'package:mycode/view/InitScreen.dart';
import 'package:mycode/view/LoginScreen.dart';
import 'package:mycode/view/SignScreen.dart';
import 'package:mycode/view/screen/ChatRoomsView.dart';
import 'package:mycode/view/screen/SettingCodeFilterScreen.dart';
import 'package:mycode/view/screen/SettingCodeScreen.dart';
import 'package:mycode/view/screen/SettingTownScreen.dart';
import 'package:mycode/view/screen/TownSearchScreen.dart';
import 'package:mycode/view/screen/SettingMemberScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 외부 서비스 초기화
  await _initialize();

  // 컨트롤러 초기화
  _initializeControllers();

  // 앱 실행
  runApp(MyCode());
}

Future<void> _initialize() async {
  // 카카오 로그인 초기화
  KakaoSdk.init(nativeAppKey: '2ab3cf1d10a4a98cdf9d505671df64f1');

  // 네이버 지도 초기화
  await FlutterNaverMap().init(
      clientId: 'xzbx4hfeqo',
      onAuthFailed: (ex) {
        switch (ex) {
          case NQuotaExceededException(:final message):
            print("사용량 초과 (message: $message)");
            break;
          case NUnauthorizedClientException() ||
          NClientUnspecifiedException() ||
          NAnotherAuthFailedException():
            print("인증 실패: $ex");
            break;
        }
      });
}

void _initializeControllers() {
  Get.put(CodeController());
  Get.put(TownController());
  Get.put(ChatController());
  Get.put(MemberController());
}

class MyCode extends StatelessWidget {
  MyCode({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "마이코드",
      initialRoute: '/',
      locale: Locale('ko', 'KR'), // 기본 언어 설정
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'), // 한국어 추가
      ],
      getPages: [
        GetPage(
            name: '/',
            page: () => InitScreen(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/login',
            page: () => LoginScreen(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/sign',
            page: () => SignScreen(),
            transition: Transition.leftToRight),
        GetPage(
            name: '/setting/town',
            page: () => SettingTownScreen(),
            transition: Transition.downToUp),
        GetPage(
            name: '/setting/town/townsearch',
            page: () => TownSearchScreen(),
            transition: Transition.rightToLeft),
        GetPage(
            name: '/setting/code',
            page: () => SettingCodeScreen(),
            transition: Transition.downToUp),
        GetPage(
            name: '/setting/code/filter',
            page: () => SettingCodeFilterScreen(),
            transition: Transition.upToDown),
        GetPage(
            name: '/setting/member',
            page: () => SettingMemberScreen(),
            transition: Transition.downToUp),
        GetPage(
            name: '/chat',
            page: () => ChatRoomsView(),
            transition: Transition.downToUp),
      ],
    );
  }
}

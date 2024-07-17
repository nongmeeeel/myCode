import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/UserController.dart';
import 'package:mycode/service/TownController.dart';
import 'package:mycode/view/HomeScreen.dart';
import 'package:mycode/view/screen/MyMapScreen.dart';
import 'package:mycode/view/screen/TownSearchScreen.dart';

void main() async {
    await _initialize();
    runApp(MyCode());
}

//지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'xzbx4hfeqo', // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );
}



class MyCode extends StatelessWidget {
  MyCode({super.key});

  @override
  Widget build(BuildContext context){
    Get.put(UserController());
    Get.put(TownController());
    Get.put(CodeController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "마이코드",
      home: HomeScreen(),
      getPages: [
        GetPage(name: '/home/map', page: () => MyMapScreen(), transition: Transition.downToUp),
        GetPage(name: '/home/map/townsearch', page: () => TownSearchScreen(), transition: Transition.rightToLeft)
      ]
    );
  }
}

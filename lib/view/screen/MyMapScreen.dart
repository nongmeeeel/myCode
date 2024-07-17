import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/model/local/User.dart';
import 'package:mycode/service/UserController.dart';
import 'package:mycode/view/screen/my_map/MyMap.dart';
import 'package:mycode/view/screen/my_map/MyMapSetting.dart';

import '../../model/third_party/Town.dart';
import '../../model/third_party/TownOne.dart';
import '../../service/TownController.dart';

class MyMapScreen extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      TownOne? userTown = _userController.userTown.value;
      print("확인2");
      return Scaffold(
        appBar: AppBar(
          title: Text("New Page"),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1, // This makes the map widget take up 3 parts
                child: MyMap(userTown: userTown)),
            Container(
                height: 130, // This makes the info widget take up 1 part
                child: MyMapSetting(userTown)),
          ],
        ),
      );
    });
  }
}

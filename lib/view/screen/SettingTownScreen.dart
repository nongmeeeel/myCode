import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/model/local/Member.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:mycode/view/screen/town_setting/TownSettingMap.dart';
import 'package:mycode/view/screen/town_setting/TownSetting.dart';

import '../../model/local/MemberTown.dart';
import '../../model/third_party/Town.dart';
import '../../service/TownController.dart';

class SettingTownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("확인2");
    return Scaffold(
      appBar: AppBar(
        title: Text("New Page"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1, // This makes the map widget take up 3 parts
              child: TownSettingMap()),
          Container(
              height: 130, // This makes the info widget take up 1 part
              child: TownSetting()),
        ],
      ),
    );
  }
}

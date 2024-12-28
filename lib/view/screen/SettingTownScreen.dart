import 'package:flutter/material.dart';
import 'package:mycode/view/screen/town_setting/TownSettingMap.dart';
import 'package:mycode/view/screen/town_setting/TownSetting.dart';

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

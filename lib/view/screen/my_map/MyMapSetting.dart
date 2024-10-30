import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mycode/service/MemberController.dart';

import '../../../model/third_party/Town.dart';
import '../../../model/third_party/TownOne.dart';
import '../../../service/TownController.dart';

class MyMapSetting extends StatelessWidget {
  MyMapSetting(this.userTown);
  final TownOne? userTown;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
         topLeft: Radius.circular(20.0), // 좌상단 모서리를 둥글게 만듭니다.
         topRight: Radius.circular(20.0), // 우상단 모서리를 둥글게 만듭니다.
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                userTown == null ? TownSettingButton() : defaultButton(userTown!.features[0].properties.emdKorNm)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TownSettingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black87
      ),
      child: TextButton(
        onPressed: () => Get.toNamed('/home/map/townsearch'),
        child: Text(
          "동네 설정",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class defaultButton extends StatelessWidget {
  defaultButton(this.emdKorNm);
  final MemberController _memberController = Get.find<MemberController>();
  final String emdKorNm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.black87
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            child: TextButton(
              onPressed: () => Get.toNamed('/home/map'),
              child: Text(
                emdKorNm,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black87,
            child: IconButton(
                color: Colors.white,
                onPressed: () => _memberController.resetTownOne(),
                icon: Icon(Icons.close)
            ),
          )
        ],
      ),
    );
  }
}


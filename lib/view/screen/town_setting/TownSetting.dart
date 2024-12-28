import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/service/MemberController.dart';

import '../../../model/local/MemberTown.dart';

class TownSetting extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MemberTown memberTown = memberController.memberTown.value!;

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
                  TownSettingButton(memberTown.title)
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class TownSettingButton extends StatelessWidget {
  TownSettingButton(this.emdKorNm);
  final String emdKorNm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Colors.black87),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TextButton(
              onPressed: () => Get.toNamed('/setting/town/townsearch'),
              child: Text(
                emdKorNm,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

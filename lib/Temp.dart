import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/service/MemberController.dart';

class Temp extends StatelessWidget {
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TextButton(
            child: Text('도시 추가', style: TextStyle(color: Colors.white)),
            onPressed: _memberController.insertTownTemp,
            style: TextButton.styleFrom(
              backgroundColor: Colors.black87,
            ),
          ),
        ),
        Container(
          child: ElevatedButton(
            onPressed: () async {
              _memberController.logout();
            } ,
            child: Text('Logout'),
          ),
        )
      ],
    );
  }
}

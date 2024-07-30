import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/service/AuthController.dart';
import 'package:mycode/service/UserController.dart';

class Temp extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TextButton(
            child: Text('도시 추가', style: TextStyle(color: Colors.white)),
            onPressed: _userController.insertTownTemp,
            style: TextButton.styleFrom(
              backgroundColor: Colors.black87,
            ),
          ),
        ),
        Container(
          child: ElevatedButton(
            onPressed: () => authController.kakaoLogout(),
            child: Text('Logout'),
          ),
        )
      ],
    );
  }
}

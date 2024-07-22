import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mycode/service/UserController.dart';
import 'package:provider/provider.dart';

import '../../model/local/User.dart';

class HomeProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/minji.jpg'),
                radius: 50.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Text("111"),
                    Row(
                      children: [
                        Text("222"),
                        Text("333"),
                      ],
                    ),
                    Text("444"),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
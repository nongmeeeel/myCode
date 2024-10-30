import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mycode/model/local/Member.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/TownController.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:mycode/view/screen/home_map/CodeGridView.dart';

import '../../common/FunctionUtil.dart';
import '../../model/local/Code.dart';
import '../../model/third_party/TownOne.dart';
import 'home_map/UserMap.dart';

class HomeMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CodeGridView(),
        ),
        Expanded(
            child: UserMap()
        ),
      ],
    );
  }
}
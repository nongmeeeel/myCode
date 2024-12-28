import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mycode/view/screen/home_map/CodeFilterWidget.dart';
import 'home_map/HomeMap.dart';

class HomeMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CodeFilterWidget(),
        Expanded(
          child: Stack(
            children: [
              MemberMap(),
            ],
          ),
        ),
      ],
    );
  }
}

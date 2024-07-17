import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../service/CodeController.dart';

class CodeGridView extends StatelessWidget {
  final CodeController codeController = Get.find<CodeController>();


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var allCodeList = codeController.allCodeList;

      if (allCodeList.isEmpty) {
        // 로딩 중이거나 데이터가 없을 때 표시할 UI
        return Center(child: CircularProgressIndicator());
      }

      // GridView.builder로 변경
      return GestureDetector(
        onTap: () => print("안녕하세요~"),
        child: Container(
          height: 148,
          width:  445,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 줄에 표시할 아이템 수
              mainAxisSpacing: 0, // 수직 간격
              crossAxisSpacing: 0 , // 수평 간격
              childAspectRatio: 1.0, // 각 아이템의 가로 세로 비율
            ),
            itemCount: allCodeList[1].codeCategories.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white, width: 1.0),
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    allCodeList[1].codeCategories[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

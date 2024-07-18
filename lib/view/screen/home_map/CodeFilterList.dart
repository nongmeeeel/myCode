import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/Code.dart';

import '../../../service/CodeController.dart';

class CodeFilterList extends StatelessWidget {
  final CodeController codeController = Get.find<CodeController>();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      List<CodeItem> itemsInHobby = codeController.itemsInHobby.value;
      List<CodeItem> itemsInHobbyFilter = codeController.itemsInHobbyFilter.value;
      bool filterViewToggle = codeController.filterViewToggle.value;
      var items = filterViewToggle
          ? itemsInHobbyFilter
          : itemsInHobby;
      return Positioned(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // 배경 없음
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6.0, // 항목 간의 수평 간격
                        runSpacing: 6.0, // 줄 간의 수직 간격
                        children: List.generate(items.length, (index) {
                          return Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${items[index].title}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(width: 2),
                                if (filterViewToggle)
                                Text(
                                  'X',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  if (!filterViewToggle) Center(
                    child: GestureDetector(
                      onTap: () => codeController.toggleFilterView(),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text("완료"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent, // 배경 없음
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 6.0, // 항목 간의 수평 간격
                  runSpacing: 6.0, // 줄 간의 수직 간격
                  children: List.generate(items.length, (index) {
                    return Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${items[index].title}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                          SizedBox(width: 2),
                          if (filterViewToggle)
                            Text(
                              'X',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );}
    );
  }
}

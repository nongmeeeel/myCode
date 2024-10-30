import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/service/MemberController.dart';

import '../../../service/CodeController.dart';

class CodeFilterList extends StatelessWidget {
  final CodeController codeController = Get.find<CodeController>();
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      List<CodeItem> itemsInHobby = codeController.itemsInHobby.value;
      List<CodeItem> itemsInHobbyFilter = _memberController.itemsInHobbyFilter.value;
      bool isItemsView = codeController.isItemsView.value;

      return Positioned(
        child: Column(
          children: [
            if (isItemsView)
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, // 배경 없음
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // 수평 스크롤 설정
                      child: Row(
                        children: List.generate(itemsInHobby.length, (index) {
                          bool isContains = false;
                          for (var item in itemsInHobbyFilter) {
                            if (item.id == itemsInHobby[index].id) {
                              isContains = true;
                            }
                          }

                          return isContains
                            ? Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${itemsInHobby[index].title}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            )
                            : GestureDetector(
                            onTap: () {
                              _memberController.addItemsInHobbyFilter(itemsInHobby[index]);
                              _memberController.updateFilterAndSelectMemberListByMap();
                            },
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${itemsInHobby[index].title}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          );

                        }),
                      ),
                    ),
                  ),

                  // 완료 click 시 선택view 닫기 및 필터 저장
                  Center(
                    child: GestureDetector(
                      onTap: () => print("채워야해"),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text("전체선택"),
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
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 6.0, // 항목 간의 수평 간격
                  runSpacing: 6.0, // 줄 간의 수직 간격
                  children: List.generate(itemsInHobbyFilter.length, (index) {
                    return GestureDetector(
                      onTap: () {
                          _memberController.removeItemsInHobbyFilter(itemsInHobbyFilter[index]);
                          _memberController.updateFilterAndSelectMemberListByMap();
                        },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${itemsInHobbyFilter[index].title}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              'X',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
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

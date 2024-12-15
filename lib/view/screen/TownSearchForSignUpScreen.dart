import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mycode/model/third_party/Town.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:mycode/service/TownController.dart';
import 'package:get/get.dart';


class TownSearchForSignUpScreen extends StatelessWidget {
  final TownController _townController = Get.find<TownController>();
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("")
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200], // 배경색
                borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
              ),
              child: Obx(
                    () => TextField(
                  controller: TextEditingController(
                    text: _townController.townSearchText.value,
                  ),
                  onChanged: (text) => _townController.townSearchTextChange(text),
                  decoration: InputDecoration(
                    hintText: '동,읍,면 으로 검색 (ex. 판교동)',
                    border: InputBorder.none, // 테두리 선 없음
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 간격 조정
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black87,
              ),
              child: TextButton(
                child: Text(
                  "현재 위치로 찾기",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),onPressed: (){},
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Obx(() {
                  List<Town> townList = _townController.townList;
                  return ListView.builder(
                    itemCount: townList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(townList[index].title),
                        onTap: () {
                          Get.back(result: townList[index]);
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

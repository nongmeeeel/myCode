import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../../repository/local/MemberRepository.dart';
import '../../service/TownController.dart';

class HomeInfoScreen extends StatelessWidget {
  final TownController _townController = Get.find<TownController>();
  final TownRepository _townRepository = TownRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CodeBox(codeBoxText: "영화"),
              SizedBox(width: 5),
              CodeBox(codeBoxText: "사진촬영"),
              SizedBox(width: 5),
              CodeBox(codeBoxText: "헬스 조져벼러 리려구"),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CodeBox(codeBoxText: "맥주 마시기"),
              SizedBox(width: 5),
              CodeBoxMain(codeBoxText: "ENTP"),
              SizedBox(width: 5),
              CodeBox(codeBoxText: "Many Things"),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CodeBox(codeBoxText: "노"),
              SizedBox(width: 5),
              CodeBox(codeBoxText: ""),
              SizedBox(width: 5),
              CodeBox(codeBoxText: ""),
            ],
          ),
          ElevatedButton(
            onPressed: () => print("ㅎㅇ"),
            child: Text("버튼이다잇")
          )
        ],
      ),
    );
  }
}

class CodeBox extends StatelessWidget {
  const CodeBox({super.key, required this.codeBoxText});

  final String codeBoxText;

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
          codeBoxText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: TextStyle(fontWeight: FontWeight.bold)
      ),
    );
  }
}

class CodeBoxMain extends StatelessWidget {
  const CodeBoxMain({super.key, required this.codeBoxText});

  final String codeBoxText;

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 3.0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
          codeBoxText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
      ),
    );
  }
}
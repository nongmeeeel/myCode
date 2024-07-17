import 'package:flutter/material.dart';

class CodeFilterList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      left: 10,
      right: 10,
      child: Container(
        height: 25, // 리스트의 높이 설정 (예시로 25으로 설정)
        decoration: BoxDecoration(
          color: Colors.transparent, // 배경 없음
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 가로로 스크롤 가능하도록 설정
          itemCount: 30, // 예시로 30개의 항목을 출력
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '항목 $index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                  SizedBox(width: 2,),
                  Text(
                    "X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

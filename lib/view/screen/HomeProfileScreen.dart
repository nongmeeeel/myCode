import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:provider/provider.dart';

import '../../model/local/Code.dart';
import '../../model/local/Member.dart';
import '../../model/local/MemberTown.dart';
import '../../model/local/response/MemberCode.dart';



class HomeProfileScreen extends StatelessWidget {
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('내 프로필'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 헤더
              Obx(() {
                Member _member = _memberController.member.value!;
                return _buildProfileHeader(_member);
              }),

              SizedBox(height: 20.0),

              // 멤버 타운
              Obx(() {
                MemberTown _memberTown = _memberController.memberTown.value!;
                return _buildTitleAndItem(
                    '내 지역',
                    _memberTown.title
                );
              }),


              SizedBox(height: 20.0),

              // 멤버 코드
              Obx(() {
                List<MemberCode?> _memberCodeList = _memberController.memberCodeList.value;
                return _buildTitleAndItemList(
                    '내 코드',
                    _memberCodeList
                        .map((memberCode) => memberCode!.codeItemTitle)
                        .toList()
                );
              })

              // _buildCategorySection(
              //     '내 코드',
              //     _memberHobbyItemTitleList
              // ),

              // _buildLikedFriendsSection(),

              // _buildCategorySection(
              //     '내 설정',
              //     controller.mySettings
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Member member) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/setting/member');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFE8EEF3), // #e8eef3
          borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
          border: Border.all(
            color: Color(0xFFCCCCCB), // #cccccb 테두리 색
            width: 1.0, // 테두리 두께
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/minji.jpg'),
              radius: 50.0,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 18.0, // 더 큰 글씨 크기
                      fontWeight: FontWeight.bold, // 굵은 글씨
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(member.gender),
                  SizedBox(height: 5.0),
                  Text(member.birthDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndItem(String title, String item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/setting/town');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFE8EEF3), // #e8eef3
          borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
          border: Border.all(
            color: Color(0xFFCCCCCB), // #cccccb 테두리 색
            width: 1.0, // 테두리 두께
          ),
        ),
        padding: EdgeInsets.all(16.0), // 내부 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0), // 제목과 내용 간격
            Text(item),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndItemList(String title, List<String> itemList) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/setting/code');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFE8EEF3), // #e8eef3
          borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
          border: Border.all(
            color: Color(0xFFCCCCCB), // #cccccb 테두리 색
            width: 1.0, // 테두리 두께
          ),
        ),
        padding: EdgeInsets.all(16.0), // 내부 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10), // 제목과 목록 간격
            Wrap(
              spacing: 8.0, // 가로 간격
              runSpacing: 8.0, // 세로 간격
              children: itemList.map((item) => _buildChipItem(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildChipItem(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3E566F),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFCCCCCB),
        ),
      ),
    );
  }




  // Widget _buildLikedFriendsSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //             '찜한 친구',
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold
  //             )
  //         ),
  //         SizedBox(height: 10),
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Row(
  //             children: controller.likedFriends.map((friend) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Chip(
  //                   label: Text(friend),
  //                   avatar: CircleAvatar(
  //                     backgroundColor: Colors.grey[300],
  //                     child: Icon(Icons.person, size: 16),
  //                   ),
  //                 ),
  //               );
  //             }).toList(),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

// class HomeProfileScreen2 extends StatelessWidget {
//   final MemberController _memberController = Get.find<MemberController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/minji.jpg'),
//                 radius: 50.0,
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Column(
//                   children: [
//                     Text("111"),
//                     Row(
//                       children: [
//                         Text("222"),
//                         Text("333"),
//                       ],
//                     ),
//                     Text("444"),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Container(
//           child: TextButton(
//             child: Text('도시 추가', style: TextStyle(color: Colors.white)),
//             onPressed: () => print("ㅎㅇ"),
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.black87,
//             ),
//           ),
//         ),
//         Container(
//           child: ElevatedButton(
//             onPressed: () async {
//               _memberController.logout();
//             } ,
//             child: Text('Logout'),
//           ),
//         )
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/service/MemberController.dart';
import 'package:mycode/view/screen/ChatRoomsView.dart';
import 'package:mycode/view/screen/HomeProfileScreen.dart';
import 'screen/HomeMapScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MemberController memberController = Get.find<MemberController>();
  int _currentIndex = 1;
  late ChatRoomsView _chatRoomView;
  late HomeMapScreen _homeMapScreen;
  late HomeProfileScreen _homeProfileScreen;
  // late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _chatRoomView = ChatRoomsView();
    _homeMapScreen = HomeMapScreen();
    _homeProfileScreen = HomeProfileScreen();
    // _currentPage = _homeMapScreen; // 초기 페이지 설정
  }

  @override
  Widget build(BuildContext context) {
    var MEMBER_NAME = memberController.member.value!.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 2.0), // 왼쪽 여백 추가
          child: Container(
            alignment: Alignment.center, // 세로 가운데 정렬
            height: AppBar().preferredSize.height, // AppBar의 높이에 맞춤
            child: Text(
              '${MEMBER_NAME} 님', // 원하는 텍스트로 변경
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Container(
          width: 150,
          child: TextButton(
              onPressed: () => Get.toNamed('/setting/town'),
              child: Row(
                children: [
                  Text(
                    "     동네 설정",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                ],
              )),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              // 여기에 아이콘 버튼 클릭 시 동작을 추가하세요
              print("Settings button pressed");
            },
          ),
          IconButton(
            icon: Icon(
              Icons.message_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // 여기에 아이콘 버튼 클릭 시 동작을 추가하세요
              print("Settings button pressed");
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _chatRoomView,
          _homeMapScreen,
          _homeProfileScreen,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              label: "채팅", icon: Icon(Icons.chat_bubble_outline)),
          BottomNavigationBarItem(
              label: "내 주변", icon: Icon(Icons.map_outlined)),
          BottomNavigationBarItem(
              label: "프로필", icon: Icon(Icons.person_2_outlined)),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            // switch (_currentIndex) {
            //   case 0:
            //     _currentPage = _homeInfoScreen;
            //     print("0입니다.");
            //     break;
            //   case 1:
            //     _currentPage = _homeMapScreen;
            //     break;
            //   case 2:
            //     _currentPage = _homeProfileScreen;
            //     break;
            //   default:
            //     _currentPage = Container(); // 예외 처리: 기본적으로 빈 컨테이너를 표시
            //     break;
            // }
          });
        },
      ),
    );
  }
}

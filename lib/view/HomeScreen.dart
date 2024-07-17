import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'screen/HomeInfoScreen.dart';
import 'screen/HomeMapScreen.dart';
import 'screen/HomeSettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  Widget _currentPage = HomeMapScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Container(
          width: 150,
          child: TextButton(
              onPressed: () => Get.toNamed('/home/map'),
              child: Row(
                children: [
                  Text(
                    "     동네 설정",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white,)
                ],
              )
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white,),
            onPressed: () {
              // 여기에 아이콘 버튼 클릭 시 동작을 추가하세요
              print("Settings button pressed");
            },
          ),
          IconButton(
            icon: Icon(Icons.message_outlined, color: Colors.white,),
            onPressed: () {
              // 여기에 아이콘 버튼 클릭 시 동작을 추가하세요
              print("Settings button pressed");
            },
          ),
        ],
      ),

      body: _currentPage,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              label: "내 주변",
              icon: Icon(Icons.map_outlined)
          ),
          BottomNavigationBarItem(
              label: "내 정보",
              icon: Icon(Icons.person)
          ),
          BottomNavigationBarItem(
              label: "설정",
              icon: Icon(Icons.settings)
          )
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                _currentPage = HomeInfoScreen();
                print("0입니다.");
                break;
              case 1:
                _currentPage = HomeMapScreen();
                break;
              case 2:
                _currentPage = HomeSettingsScreen();
                break;
              default:
                _currentPage = Container(); // 예외 처리: 기본적으로 빈 컨테이너를 표시
                break;
            }
          });
        },
      ),
    );
  }
}
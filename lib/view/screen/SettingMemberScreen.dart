import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/third_party/Town.dart';
import 'package:mycode/view/screen/TownSearchForSignUpScreen.dart';
import '../../service/MemberController.dart';

class SettingMemberScreen extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("프로필 수정"),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/newjeans.jpg', // 배경 이미지
              fit: BoxFit.cover,
            ),
          ),
          // 상단 텍스트
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '프로필 수정',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 메인 콘텐츠
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // 이름 입력
                              Expanded(
                                child: TextField(
                                  controller: memberController.memberFormNameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '이름',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  onChanged: (_) => memberController.checkMemberFormValid(),
                                ),
                              ),
                              SizedBox(width: 16),

                              // 성별 선택
                              Obx(() {
                                String memberFormGender = memberController.memberFormGender.value;
                                return  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ChoiceChip(
                                      label: Text('남'),
                                      selected: memberFormGender == '남',
                                      onSelected: (_) => memberController.setMemberFormGender('남'),
                                    ),
                                    SizedBox(width: 16),
                                    ChoiceChip(
                                      label: Text('여'),
                                      selected: memberFormGender == '여',
                                      onSelected: (_) => memberController.setMemberFormGender('여'),
                                    ),
                                  ],
                                );
                              })

                            ],
                          ),
                          SizedBox(height: 16),
                          // 생년월일 선택
                          Obx(() {
                            DateTime? memberFormBirthDate = memberController.memberFormBirthDate.value;
                            return TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '생년월일',
                                prefixIcon: Icon(Icons.calendar_today) ,
                              ),
                              onTap: () async {
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  locale: const Locale("ko", "KR"), // 한국어로 변경
                                );
                                if (pickedDate != null) {
                                  memberController.setMemberFormBirthDate(pickedDate);
                                }
                              },
                              controller: TextEditingController(
                                text: memberFormBirthDate != null
                                    ? '${memberFormBirthDate!.year}-${memberFormBirthDate!.month.toString().padLeft(2, '0')}-${memberController.memberFormBirthDate.value!.day.toString().padLeft(2, '0')}'
                                    : '',
                              ),
                            );
                          }),

                          SizedBox(height: 24),
                          // '다음' 버튼
                          Obx(() => ElevatedButton(
                            onPressed: memberController.isMemberFormValid.value ? () {
                              memberController.updateMember();
                              Get.back();
                            } : null,
                            child: Text('수정',style: TextStyle(color: Colors.white70),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              textStyle: TextStyle(fontSize: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )),
                          SizedBox(height: 16),
                          // 로그아웃 버튼
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                memberController.logout();
                              },
                              child: Text('Logout'),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
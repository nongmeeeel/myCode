import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/MemberController.dart';

class SettingCodeFilterScreen extends StatelessWidget {
  final CodeController _codeController = Get.find<CodeController>();
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    CodeType? hobby = _codeController.allCodeList.firstWhere(
      (item) => item.title == '취미',
      orElse: () => throw StateError('취미 아이템을 찾을 수 없습니다'),
    );

    List<CodeCategory> hobbyCategoryList = hobby.codeCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('필터 선택'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: hobbyCategoryList.length,
                itemBuilder: (context, categoryIndex) {
                  final category = hobbyCategoryList[categoryIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 카테고리 제목
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 아이템 리스트
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: category.codeItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, itemIndex) {
                            final item = category.codeItems[itemIndex];
                            return Obx(() {
                              final isSelected =
                                  _codeController.isSelectedFilter(item.id);
                              return GestureDetector(
                                onTap: () => _codeController
                                    .toggleFilterItemSelect(item.id),
                                child: Column(
                                  children: [
                                    // 이미지
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.orange,
                                                  width: 3)
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/minji.jpg'),
                                            fit: BoxFit.cover,
                                            colorFilter: isSelected
                                                ? ColorFilter.mode(
                                                    Colors.white
                                                        .withOpacity(0.5),
                                                    BlendMode.lighten)
                                                : null,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.orange,
                                                    size: 24,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // 제목
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.orange
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16), // 버튼과 리스트 사이 간격
            Obx(() {
              return ElevatedButton(
                onPressed: () {
                  // 선택된 아이템들 저장 로직
                  _memberController.updateMemberCodeFilterMap();

                  Get.closeAllSnackbars();
                  Get.back();
                  Get.snackbar('관심사 저장',
                      '${_codeController.selectedFilterItemSet.length}개의 관심사가 저장되었습니다.',
                      backgroundColor: Colors.green.shade100);
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.orange),
                child: Text(
                  '저장하기 (${_codeController.selectedFilterItemSet.length}/10)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

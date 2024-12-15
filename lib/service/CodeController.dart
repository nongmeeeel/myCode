import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/repository/local/MemberRepository.dart';

import '../repository/local/CodeRepository.dart';

class CodeController extends GetxController {
  final CodeRepository _codeRepository = CodeRepository();
  final MemberRepository memberRepository = MemberRepository();

  // 코드 전체 목록
  RxList<CodeType> allCodeList = <CodeType>[].obs;
  RxList<CodeItem> allCodeItemList = <CodeItem>[].obs;

  RxSet<int> selectedItemIdSet = <int>{}.obs;



  // 코드 LIST 초기화
  Future<void> fetchAllCodeList() async {
    List<CodeType> _allCodeList = await _codeRepository.fetchAllCodeListAPI();

    List<CodeItem> _allCodeItemList = allCodeList
        .where((codeType) => codeType.title == '취미') // '취미' 필터링
        .expand((codeType) => codeType.codeCategories) // 카테고리 펼치기
        .expand((category) => category.codeItems) // 모든 CodeItem 펼치기
        .toList();

    allCodeList.assignAll(_allCodeList);
    allCodeItemList.assignAll(_allCodeItemList);
  }

  void setSelectedItemIdSet(Set<int> codeItemIdSet) {
    selectedItemIdSet.assignAll(codeItemIdSet);
  }

  // 프로필 내 Code 선택
  void toggleItemSelect(int itemId) {
    if (selectedItemIdSet.contains(itemId)) {
      selectedItemIdSet.remove(itemId);
    } else {
      if (selectedItemIdSet.length >= 10) {
        Get.dialog(
          AlertDialog(
            title: Center(
                child: Text('MYCODE',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    )
                )
            ),
            content: Text('관심사는 최대 10개 까지 선택할 수 있습니다.'),
            actions: [
              TextButton(
                child: Center(child: Text('확인')),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        );
      } else {
        selectedItemIdSet.add(itemId);
        print(selectedItemIdSet);
      }
    }
  }

  // 선택된 항목이면 true 반환.
  bool isSelected(int itemId) => selectedItemIdSet.contains(itemId);

}
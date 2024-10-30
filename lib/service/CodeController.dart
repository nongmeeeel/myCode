import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/repository/local/MemberRepository.dart';
import 'package:mycode/service/MemberController.dart';

import '../repository/local/CodeRepository.dart';

class CodeController extends GetxController {
  final MemberController memberController = Get.find<MemberController>();
  final CodeRepository _codeRepository = CodeRepository();
  final MemberRepository memberRepository = MemberRepository();

  // 코드 전체 목록
  RxList<CodeType> allCodeList = <CodeType>[].obs;
  // 취미 목록 안 items 목록
  RxList<CodeItem> itemsInHobby = <CodeItem>[].obs;
  // ItemsVIew toggle
  RxBool isItemsView = false.obs;
  // 현재 선택된 CodeCategory
  Rx<int> clickedCategoryIndex = 99.obs;



  // 코드 LIST 초기화
  Future<void> fetchAllCodeList() async {
    List<CodeType> _allCodeList = await _codeRepository.fetchAllCodeListAPI();
    allCodeList.assignAll(_allCodeList);
  }

  // 선택된 카테고리 및 해당 카테고리의 아이템들 세팅
  void _setItemsInCategory(int index) {
    var codeCategory = allCodeList[1].codeCategories[index];
    List<CodeItem> _codeItemList = [];
    for(var item in codeCategory.codeItems){
      _codeItemList.add(item);
    }
    itemsInHobby.assignAll(_codeItemList);
    isItemsView.value = true;
  }

  void setClickedCategory(int index) {
    if(clickedCategoryIndex.value == index) {
      clickedCategoryIndex.value = 99;
      isItemsView.value = false;
    } else {
      clickedCategoryIndex.value = index;
      _setItemsInCategory(index);
    }
  }
}
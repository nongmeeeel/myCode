import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mycode/model/local/Code.dart';

import '../repository/local/CodeRepository.dart';

class CodeController extends GetxController {
  final CodeRepository _codeRepository = CodeRepository();

  RxList<CodeType> allCodeList = <CodeType>[].obs;
  RxList<CodeItem> itemsInHobby = <CodeItem>[].obs;
  RxList<CodeItem> itemsInHobbyFilter = <CodeItem>[].obs;
  RxBool isItemsView = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCodeList();
  }

  Future<void> getAllCodeList() async {
    List<CodeType> _allCodeList = await _codeRepository.getAllCodeListAPI();
    allCodeList.assignAll(_allCodeList);
  }

  void setItemsInCategory(CodeCategory codeCategory) {
    List<CodeItem> _codeItemList = [];
    for(var item in codeCategory.codeItems){
      _codeItemList.add(item);
    }
    itemsInHobby.assignAll(_codeItemList);
    isItemsView.value = true;
  }

  void addItemsInHobbyFilter(CodeItem item) {
    itemsInHobbyFilter.add(item);
  }

  void removeItemsInHobbyFilter(CodeItem item) {
    itemsInHobbyFilter.remove(item);
  }

  void searchUserListWithFilter() async {
    List<int> itemIdList = [];
    for(var item in itemsInHobbyFilter) {
      itemIdList.add(item.id);
    }
    await _codeRepository.insertUserCodeFilterMapAPI(itemIdList);
    isItemsView.value = false;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mycode/repository/local/UserRepository.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../model/third_party/Town.dart';

class TownController extends GetxController {
  final TownRepository _townRepository = TownRepository();

  RxList<Town> townList = <Town>[].obs;
  RxString searchText = "".obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchText, (_) => selectTownListByTownNmAPI(searchText.value), time: Duration(milliseconds: 300));
  }

  // '동' 리스트 가져오기
  Future<void> selectTownListByTownNmAPI(String townNm) async {
    List<Town> townListResult = await _townRepository.selectTownListByTownNmAPI(townNm);
    townList.assignAll(townListResult);
    update();
  }

  void searchTextChange(String text) {
    searchText.value = text;
  }

}
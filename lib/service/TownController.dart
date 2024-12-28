import 'package:get/get.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../model/third_party/Town.dart';

class TownController extends GetxController {
  final TownRepository _townRepository = TownRepository();

  RxList<Town> townList = <Town>[].obs;
  RxString townSearchText = "".obs;

  @override
  void onInit() {
    super.onInit();
    debounce(
        townSearchText, (_) => searchTownListByTownNmAPI(townSearchText.value),
        time: Duration(milliseconds: 500));
  }

  // '동' 리스트 가져오기
  Future<void> searchTownListByTownNmAPI(String townNm) async {
    List<Town> result = await _townRepository.searchTownListByTownNmAPI(townNm);
    townList.assignAll(result);
  }

  void townSearchTextChange(String text) {
    townSearchText.value = text;
  }
}

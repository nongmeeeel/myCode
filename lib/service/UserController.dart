
import 'package:get/get.dart';
import 'package:mycode/model/local/UserTown.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../common/FunctionUtil.dart';
import '../model/third_party/Town.dart';
import '../model/third_party/TownOne.dart';
import '../model/local/User.dart';
import '../repository/local/UserRepository.dart';

// 상태 관리를 위한 stateNotifier와 State 정의
class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final TownRepository _townRepository = TownRepository();

  RxList<User> userList = <User>[].obs;
  Rx<User?> user = Rx<User?>(null);
  Rx<TownOne?> userTown = Rx<TownOne?>(null);

  Rx<double> centerY = Rx<double>(37.3946); // 직접 초기화
  Rx<double> centerX = Rx<double>(127.1107); // 직접 초기화
  Rx<double> zoomLevel = Rx<double>(14.4); // 직접 초기화

  // 멤버 목록 조회
  Future<void> fetchUserList() async {
    List<User> _userList = await _userRepository.fetchUserListAPI();
    userList.assignAll(_userList);
  }

  Future<bool> fetchUser() async {
    User? _user = await _userRepository.fetchUser();
    if(_user == null){
      user.value = null;
      return false;
    } else {
      TownOne _userTown = await _townRepository.getTownByTownCodeAPI(_user.userTown.townCode);
      centerY.value = _user.userTown.lat;
      centerX.value = _user.userTown.lng;
      zoomLevel.value = _user.userTown.zoomLevel;
      user.value = _user;
      userTown.value = _userTown;
      return true;
    }
  }

  Future<void> updateUserTown(Town town) async {
    TownOne _userTown = await _townRepository.getTownByTownCodeAPI(town.emdCd);
    List<double> centerYX = townOneToCenterYX(_userTown);
    double zoom = townOneToZoomLevel(_userTown);
    _userRepository.updateUserTown(town,centerYX[0],centerYX[1],zoom);
    centerY.value = centerYX[0];
    centerX.value = centerYX[1];
    zoomLevel.value = zoom;
    userTown.value = _userTown;
  }

  void resetTownOne() {
    print("확인1");
    userTown.value = null;
    centerY.value = 37.3946;
    centerX.value = 127.1107;
    zoomLevel.value = 14.4;
  }

  void insertTownTemp() async {
    List<String> townCodeList = [
      '41135101',
      '41135102',
      '41135103',
      '41135104',
      '41135105',
      '41135106',
      '41135107',
      '41135108',
      '41135109',
      '41135110',
      '41135111',
      '41135112',
      '41135113',
      '41135114',
      '41135115',
      '41135116',
      '41135117',
      '41135118',
    ];
    for (String item in townCodeList) {
      TownOne _userTown = await _townRepository.getTownByTownCodeAPI(item);
      List<double> centerYX = townOneToCenterYX(_userTown);
      double zoom = townOneToZoomLevel(_userTown);
      var town = _userTown.features[0].properties;
      UserTown userTown = UserTown(
          townCode: town.emdCd,
          fullNm: town.fullNm,
          nm: town.emdKorNm,
          engNm: town.emdEngNm,
          lat: centerYX[0],
          lng: centerYX[1],
          zoomLevel: zoom
      );
      _userRepository.insertTownTemp(userTown);
    }
  }
  
  // void getXYZoomLevel(TownOne townOne) {
  //   List<double> centerYX = townOneToCenterYX(townOne);
  //   centerY.value = centerYX[0];
  //   centerX.value = centerYX[1];
  //   zoomLevel.value = townOneToZoomLevel(townOne);
  // }
}
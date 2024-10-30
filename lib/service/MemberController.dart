
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/common/auth/TokenUtil.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/TownController.dart';
import '../model/local/Member.dart';
import 'package:mycode/common/auth/KakaoLoginUtil.dart';
import 'package:mycode/common/auth/KakaoTokenUtil.dart';
import 'package:mycode/model/local/UserTown.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../common/FunctionUtil.dart';
import '../model/third_party/Town.dart';
import '../model/third_party/TownOne.dart';
import '../repository/local/MemberRepository.dart';

class MemberController extends GetxController {
  final MemberRepository _memberRepository = MemberRepository();
  final TownRepository _townRepository = TownRepository();
  final KakaoTokenUtil kakaoTokenUtil = KakaoTokenUtil();
  final KakaoLoginUtil kakaoLoginUtil = KakaoLoginUtil();

  // MEMBER 인증, 인가 정보
  RxBool isInit = false.obs;
  RxBool isLogin = false.obs;
  RxBool isMember = false.obs;
  RxBool isVip = false.obs;
  RxBool isAdmin = false.obs;
  Rx<kakao.User?> kakaoUser = Rx<kakao.User?>(null);

  // MEMBER 정보
  Rx<Member?> member = Rx<Member?>(null);
  Rx<TownOne?> memberTown = Rx<TownOne?>(null);
  Rx<double> centerY = Rx<double>(37.3946); // 직접 초기화
  Rx<double> centerX = Rx<double>(127.1107); // 직접 초기화
  Rx<double> zoomLevel = Rx<double>(14.4); // 직접 초기화

  // MEMBER LIST
  RxList<Member> memberList = <Member>[].obs;

  // Map 정보
  Rx<NLatLngBounds?> bounds = Rx<NLatLngBounds?>(null);

  // 코드 필터 목록
  RxList<CodeItem> itemsInHobbyFilter = <CodeItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkMemberInfo();
  }

  void addItemsInHobbyFilter(CodeItem codeItem) {
    itemsInHobbyFilter.add(codeItem);
  }
  void removeItemsInHobbyFilter(CodeItem codeItem) {
    itemsInHobbyFilter.remove(codeItem);
  }

  void setBounds(NLatLngBounds boundsData) {
    this.bounds.value = boundsData;
  }

  // MEMBER 인증, 인가 체크
  Future<void> checkMemberInfo() async {
    await Future.wait([
      TokenUtil.isLogin().then((value) => isLogin.value = value),
      TokenUtil.isMember().then((value) => isMember.value = value),
      TokenUtil.isVip().then((value) => isVip.value = value),
      TokenUtil.isAdmin().then((value) => isAdmin.value = value),
    ]);
    isInit.value = true;
  }

  // LOGIN
  Future<void> login() async {
    bool login = await kakaoLoginUtil.login();
    if (login == true) {
      kakao.User kUser = await kakao.UserApi.instance.me();
      String id = kUser.id.toString();
      String? nickname = kUser.kakaoAccount?.profile?.nickname;

      await _memberRepository.loginAPI(id, 'qwe321!!qwe');
    } else {
      // 임시 : login 실패 시 작업 (카카오 로그인 결과 활용)
    }
    await checkMemberInfo();
  }

  // LOGOUT
  Future<void> logout() async {
    await TokenUtil.removeTokens();
    await resetMember();
    await checkMemberInfo();
  }

  // 멤버 정보 조회
  Future<bool> fetchMember() async {
    Member? _member = await _memberRepository.fetchMemberAPI();

    if(_member == null){
      member.value = null;
      return false;
    } else {
      TownOne _userTown = await _townRepository.getTownByTownCodeAPI(_member.memberTown.townCode);
      centerY.value = _member.memberTown.lat;
      centerX.value = _member.memberTown.lng;
      zoomLevel.value = _member.memberTown.zoomLevel;
      member.value = _member;
      memberTown.value = _userTown;
      return true;
    }
  }

  Future<void> updateFilterAndSelectMemberListByMap() async {
    Map<String, dynamic> data = {
      'northEastLat': bounds.value?.northEast.latitude,
      'northEastLng': bounds.value?.northEast.longitude,
      'southWestLat': bounds.value?.southWest.latitude,
      'southWestLng': bounds.value?.southWest.longitude,
      'itemsInHobbyFilter': itemsInHobbyFilter
    };
    List<Member> memberList = await _memberRepository.updateFilterAndSelectMemberListByMapAPI(data);
  }

  // 멤버 정보 초기화
  Future<void> resetMember() async {
      centerY.value = 37.3946;
      centerX.value = 127.1107;
      zoomLevel.value = 14.4;
      member.value = null;
      memberTown.value = null;
  }

  // 멤버 목록 조회
  Future<void> fetchMemberList() async {
    List<Member> _userList = await _memberRepository.fetchMemberListAPI();
    memberList.assignAll(_userList);
  }

  // 멤버 주소 수정
  Future<void> updateMemberTown(Town town) async {
    TownOne _userTown = await _townRepository.getTownByTownCodeAPI(town.emdCd);
    List<double> centerYX = townOneToCenterYX(_userTown);
    double zoom = townOneToZoomLevel(_userTown);
    _memberRepository.updateMemberTownAPI(town,centerYX[0],centerYX[1],zoom);
    centerY.value = centerYX[0];
    centerX.value = centerYX[1];
    zoomLevel.value = zoom;
    memberTown.value = _userTown;
  }

  // 멤버 주소 삭제
  void resetTownOne() {
    memberTown.value = null;
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
      // _memberRepository.insertTownTemp(userTown);
    }
  }
}
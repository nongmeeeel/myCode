
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/common/auth/TokenUtil.dart';
import 'package:mycode/model/local/Code.dart';
import 'package:mycode/model/local/request/SignUpRequestDTO.dart';
import 'package:mycode/repository/local/CodeRepository.dart';
import 'package:mycode/service/CodeController.dart';
import 'package:mycode/service/TownController.dart';
import '../model/local/MapInfo.dart';
import '../model/local/Member.dart';
import 'package:mycode/common/auth/KakaoLoginUtil.dart';
import 'package:mycode/common/auth/KakaoTokenUtil.dart';
import 'package:mycode/model/local/MemberTown.dart';
import 'package:mycode/repository/third_party/TownRepository.dart';

import '../common/FunctionUtil.dart';
import '../model/local/response/FetchMemberResponseDTO.dart';
import '../model/local/response/MemberCode.dart';
import '../model/third_party/Town.dart';
import '../repository/local/MemberRepository.dart';

class MemberController extends GetxController {
  final MemberRepository _memberRepository = MemberRepository();
  final CodeController _codeController = Get.find<CodeController>();
  final TownController _townController = Get.find<TownController>();
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
  Rx<MemberTown?> memberTown = Rx<MemberTown?>(null);
  RxList<MemberCode?> memberCodeList = RxList([]);
  RxList<CodeItem> memberFilterItemList = RxList([]);

  // Sign 시, 최초 Form 정보 임시 저장
  final signFormNameController = TextEditingController();
  RxString signFormGender = ''.obs;
  Rx<DateTime?> signFormBirthDate = Rx<DateTime?>(null);
  Rx<MemberTown?> signFormTown = Rx<MemberTown?>(null);
  RxBool isSignFormValid = false.obs;

  // Member 정보 수정
  final memberFormNameController = TextEditingController();
  RxString memberFormGender = ''.obs;
  Rx<DateTime?> memberFormBirthDate = Rx<DateTime?>(null);
  RxBool isMemberFormValid = false.obs;

  // MEMBER LIST
  RxList<Member> allMemberList = RxList([]);
  RxList<Member> mapMemberList = RxList([]);

  // CODE

  // NaverMapController
  Rx<NaverMapController?> nController = Rx<NaverMapController?>(null);

  // Map 정보
  Rx<MapInfo?> mapInfo = MapInfo(
    eastLat: 37.39879, // 판교역 기준 초기화
    eastLng: 127.11719,
    westLat: 37.38979,
    westLng: 127.10579,
  ).obs;





  @override
  void onInit() {
    super.onInit();
    checkMemberInfo();
  }

  @override
  void onClose() {
    signFormNameController.dispose(); // 컨트롤러를 닫을 때 메모리 해제
    super.onClose();
  }





//------------------------MEMBER 로직----------------------------//
  // 멤버 정보 FETCH
  Future<void> fetchMember() async {
    FetchMemberResponseDTO? fetchMemberResponseDTO = await _memberRepository.fetchMemberAPI();

    if(fetchMemberResponseDTO != null) {
      Member _member = fetchMemberResponseDTO.member;
      List<MemberCode> _memberCodeList = fetchMemberResponseDTO.memberCodeList;

      member.value = _member;
      memberTown.value = _member.memberTown;
      memberCodeList.value = _memberCodeList;

      // CodeType? _codeTypeHobby = _codeTypeList
      //     .where((item) => item.title == '취미')
      //     .firstOrNull;
      // if(_codeTypeHobby != null){
      //   memberHobby.value = _codeTypeHobby;
      //   var temp = 1;
      // }
    }
  }

  // 멤버 리스트 정보 FETCH
  Future<void> fetchMemberList() async {
    List<Member> _userList = await _memberRepository.fetchMemberListAPI();
    allMemberList.assignAll(_userList);
  }

  // map 좌표에 해당하는 멤버 리스트 조회
  Future<List<Member>> selectMemberListByMapInfo() async {
    Map<String, dynamic> data = {
      'northEastLat': mapInfo.value!.eastLat,
      'northEastLng': mapInfo.value!.eastLng,
      'southWestLat': mapInfo.value!.westLat,
      'southWestLng': mapInfo.value!.westLng,
    };
    List<Member> memberList = await _memberRepository.selectMemberListByMapInfoAPI(data);

    mapMemberList.assignAll(memberList);
    return memberList;
  }

  Future<void> updateMember() async {
    DateTime date = memberFormBirthDate.value!;
    String formattedDate = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

    Member? result = await _memberRepository.updateMember(memberFormNameController.text, memberFormGender.value, formattedDate);
    if (result != null) {
      member.value = result;
    }
  }

 //----------------------------------------------------//






  //------------------------TOWN 로직----------------------------//
  // 멤버 주소 수정
  Future<void> updateMemberTown(Town town) async {
    memberTown.value = MemberTown(id: town.id, title: town.title, x: town.x, y: town.y);
    _memberRepository.updateMemberTownAPI(town);
    // update();
  }
//----------------------------------------------------//







//------------------------CODE 로직----------------------------//
  Future<void> updateMemberCodeMap() async {
    Set<int> selectedItemIdSet = _codeController.selectedItemIdSet;
    await _memberRepository.updateMemberCodeMap(selectedItemIdSet);
    List<MemberCode> _memberCodeList = await _memberRepository.selectMemberCodeList();
    memberCodeList.assignAll(_memberCodeList);
  }
//----------------------------------------------------//



//-------------------------기타 로직----------------------------//
  void setMapInfo(NLatLngBounds bounds) {
    MapInfo _mapInfo = MapInfo(
        eastLat: bounds.northEast.latitude,
        eastLng: bounds.northEast.longitude,
        westLat: bounds.southWest.latitude,
        westLng: bounds.southWest.longitude
    );
    mapInfo.value = _mapInfo;
  }
//----------------------------------------------------//






  //------------------------최초 Sign 시 로직----------------------------//
  // 유효성 검사 업데이트 함수
  void checkSignFormValid() {
    // 이름, 성별, 생년월일이 모두 채워졌는지 확인
    isSignFormValid.value = signFormNameController.text.isNotEmpty &&
        signFormGender.value.isNotEmpty &&
        signFormBirthDate.value != null &&
        signFormTown.value != null;
  }

  // 성별 선택 함수
  void setSignFormGender(String gender) {
    signFormGender.value = gender;
    checkSignFormValid();
  }

  // 생년월일 설정 함수
  void setSignFormBirthDate(DateTime date) {
    signFormBirthDate.value = date;
    checkSignFormValid();
  }

  // Town 설정 함수
  void setSignFormTown(Town town) {
    MemberTown memberTown = MemberTown(
        id: town.id,
        title: town.title,
        x: town.x,
        y: town.y
    );
    signFormTown.value = memberTown;
    checkSignFormValid();
  }

  // 가입
  void signUp() async {
    DateTime date = signFormBirthDate.value!;
    String formattedDate = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

    SignUpRequestDTO signUpRequestDTO = SignUpRequestDTO(
        name: signFormNameController.text,
        gender: signFormGender.value,
        birthDate: formattedDate ,
        memberTown: signFormTown.value!
    );
    await _memberRepository.signUpAPI(signUpRequestDTO);
    await checkMemberInfo();
  }
  //----------------------------------------------------//



  //------------------------Member 정보 수정 로직----------------------------//
  // 유효성 검사 업데이트 함수
  void checkMemberFormValid() {
    // 이름, 성별, 생년월일이 모두 채워졌는지 확인
    isMemberFormValid.value = memberFormNameController.text.isNotEmpty &&
        memberFormGender.value.isNotEmpty &&
        memberFormBirthDate.value != null;
  }

  // 성별 선택 함수
  void setMemberFormGender(String gender) {
    memberFormGender.value = gender;
    checkMemberFormValid();
  }

  // 생년월일 설정 함수
  void setMemberFormBirthDate(DateTime date) {
    memberFormBirthDate.value = date;
    checkMemberFormValid();
  }
  //----------------------------------------------------//





//------------------------로그인,로그아웃 / 인증인가----------------------------//
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
      String nickname = kUser.kakaoAccount?.profile?.nickname ?? "";

      await _memberRepository.loginAPI(id, 'qwe321!!qwe', 'K', nickname);
    } else {
      // 임시 : login 실패 시 작업 (카카오 로그인 결과 활용)
    }
    await checkMemberInfo();
  }

  // LOGOUT
  Future<void> logout() async {
    await TokenUtil.removeTokens();
    member.value = null;
    memberTown.value = null;
    memberCodeList.value = [];
    memberFilterItemList.value = [];
    checkMemberInfo();
  }
  //----------------------------------------------------//









  // void insertTownTemp() async {
  //   List<String> townCodeList = [
  //     '41135101',
  //     '41135102',
  //     '41135103',
  //     '41135104',
  //     '41135105',
  //     '41135106',
  //     '41135107',
  //     '41135108',
  //     '41135109',
  //     '41135110',
  //     '41135111',
  //     '41135112',
  //     '41135113',
  //     '41135114',
  //     '41135115',
  //     '41135116',
  //     '41135117',
  //     '41135118',
  //   ];
  //   for (String item in townCodeList) {
  //     TownOne _userTown = await _townRepository.getTownByTownCodeAPI(item);
  //     List<double> centerYX = townOneToCenterYX(_userTown);
  //     double zoom = townOneToZoomLevel(_userTown);
  //     var town = _userTown.features[0].properties;
  //     UserTown userTown = UserTown(
  //         townCode: town.emdCd,
  //         fullNm: town.fullNm,
  //         nm: town.emdKorNm,
  //         engNm: town.emdEngNm,
  //         lat: centerYX[0],
  //         lng: centerYX[1],
  //         zoomLevel: zoom
  //     );
  //     // _memberRepository.insertTownTemp(userTown);
  //   }
  // }
}
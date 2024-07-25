import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/common/auth/KakaoLoginUtil.dart';
import 'package:mycode/common/auth/KakaoTokenUtil.dart';

class AuthController extends GetxController {
  KakaoTokenUtil kakaoTokenUtil = KakaoTokenUtil();
  KakaoLoginUtil kakaoLoginUtil = KakaoLoginUtil();

  RxBool isAuthenticated = false.obs;
  Rx<User?> kakaoUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    validateKakaoToken();
  }

  Future<void> validateKakaoToken () async {
    bool _isAuthenticated = await kakaoTokenUtil.validateKakaoToken();
    isAuthenticated.value = _isAuthenticated;
    if (_isAuthenticated) {
      kakaoUser.value = await UserApi.instance.me();
    } else {
      kakaoUser.value = null;
    }
  }

  Future<bool> kakaoLogin() async {
    await kakaoLoginUtil.login();
    await validateKakaoToken();
    bool loginFlag = kakaoUser.value != null ? true : false;
    return loginFlag;
  }

  Future kakaoLogout() async {
    await kakaoLoginUtil.logout();
    validateKakaoToken();
  }

}
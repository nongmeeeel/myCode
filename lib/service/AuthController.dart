import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:mycode/common/auth/KakaoLoginUtil.dart';
import 'package:mycode/common/auth/KakaoTokenUtil.dart';

import 'CodeController.dart';
import 'TownController.dart';
import 'UserController.dart';

class AuthController extends GetxController {
  KakaoTokenUtil kakaoTokenUtil = KakaoTokenUtil();
  KakaoLoginUtil kakaoLoginUtil = KakaoLoginUtil();

  RxBool isLogin = false.obs;
  Rx<User?> kakaoUser = Rx<User?>(null);


  Future<bool> loginCheck () async {
    bool _isLogin = await kakaoTokenUtil.loginCheck();
    isLogin.value = _isLogin;
    if (_isLogin) {
      kakaoUser.value = await UserApi.instance.me();
      return true;
    } else {
      kakaoUser.value = null;
      return false;
    }
  }

  Future<void> kakaoLogin() async {
    await kakaoLoginUtil.login();
    loginCheck();
    Get.toNamed("/loading");
  }

  Future<void> kakaoLogout() async {
    await kakaoLoginUtil.logout();
    Get.delete<UserController>();
    Get.delete<TownController>();
    Get.delete<CodeController>();
    loginCheck();
    Get.toNamed("/loading");
  }

}
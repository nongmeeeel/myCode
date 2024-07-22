import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../common/login/SocialLogin.dart';

class KakaoLoginController extends GetxController {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;

  KakaoLoginController(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }

}
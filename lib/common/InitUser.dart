import 'package:mycode/service/AuthController.dart';
import 'package:mycode/service/UserController.dart';

import '../model/local/User.dart';

Future<String> initUser() async {
  AuthController authController = AuthController();
  UserController userController = UserController();

  bool loginCheck = await authController.loginCheck();
  User? user = null;

  if(loginCheck) {
    await userController.fetchUser();
    user = userController.user.value;
  }

  if(loginCheck == true && user != null) {
    return "complete";
  } else if (loginCheck == true) {
    return "needSign";
  } else {
    return "needLogin";
  }
}
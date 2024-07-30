import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mycode/service/AuthController.dart';

class AuthApiInterceptor extends Interceptor {
  final AuthController authController = Get.find<AuthController>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    int? kakaoId = authController.kakaoUser.value?.id;
    if (kakaoId != null) {
      options.headers['KAKAO_ID'] = kakaoId;
      handler.next(options);
    } else {
      handler.reject(DioException.requestCancelled(
        requestOptions: options,
        reason: "AuthAPI 로그인 검증 실패",
        stackTrace: StackTrace.empty,
      ));
    }


    // bool isLogin = await authController.loginCheck();
    //
    // if(isLogin) {
    //   handler.next(options);
    // } else {
    //   handler.reject(DioException.requestCancelled(
    //     requestOptions: options,
    //     reason: "AuthAPI 로그인 검증 실패",
    //     stackTrace: StackTrace.empty,
    //   ));
    // }

  }
}

Dio getAuthDio() {
  Dio dio = Dio();
  dio.interceptors.add(AuthApiInterceptor());
  return dio;
}
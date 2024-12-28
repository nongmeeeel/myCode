import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mycode/service/MemberController.dart';

class AuthApiInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final MemberController memberController = Get.find<MemberController>();
    int? kakaoId = memberController.kakaoUser.value?.id;
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

  }
}

Dio getAuthDio() {
  Dio dio = Dio();
  dio.interceptors.add(AuthApiInterceptor());
  return dio;
}
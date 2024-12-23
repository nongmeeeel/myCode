import 'package:dio/dio.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:mycode/service/MemberController.dart';

import 'auth/TokenUtil.dart';

class BaseDio {
  final Dio dio;

  BaseDio(String basePath)
      : dio = Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:8080/api/v1' + basePath,
          connectTimeout: Duration(milliseconds: 500000),
          receiveTimeout: Duration(milliseconds: 300000),
          headers: {
            'Content-Type': 'application/json',
          },
        ))
          ..interceptors.add(InterceptorsWrapper(
            onRequest: (options, handler) async {
              String? accessToken = await TokenUtil.getAccessToken();
              if (accessToken != null) {
                options.headers['access-token'] = accessToken;
              }
              print('*** Request 헤더 : ${options.headers}');

              // API URL 로깅
              print('***** API 요청 ***** : ${options.uri}');
              return handler.next(options);
            },
            onResponse: (response, handler) {
              return handler.next(response);
            },
            onError: (e, handler) async {
              Dio tokenDio = Dio();
              MemberController memberController = Get.find<MemberController>();

              var errorCode = e.response?.data['code'];
              if (errorCode == 9002) {
                // 기존 request 정보 저장
                RequestOptions originRequest = e.requestOptions;

                // Storage에서 Refresh token을 꺼내 새로운 Access token 요청
                String? refreshToken = await TokenUtil.getRefreshToken();
                try {
                  Response response = await tokenDio.post(
                      'http://10.0.2.2:8080/api/v1/refresh-token',
                      options:
                          Options(headers: {'Refresh-Token': refreshToken}));

                  // 성공 시 재발급된 토큰 저장
                  if (response.statusCode == 200) {
                    await TokenUtil.saveTokens(response.headers);

                    // 재발급된 토큰으로 원래의 요청 다시 시도
                    String? accessToken = await TokenUtil.getAccessToken();
                    originRequest.headers['Access-Token'] = accessToken;
                    final reResponse = await tokenDio.request(
                      originRequest.baseUrl + originRequest.path,
                      options: Options(
                        method: originRequest.method,
                        headers: originRequest.headers,
                      ),
                      data: originRequest.data,
                      queryParameters: originRequest.queryParameters,
                    );
                    return handler.resolve(reResponse);
                  }
                } catch (e) {
                  print('@@@@@@ 토큰 재발급 에러 @@@@@@');
                  print('요청URL: ${originRequest.uri}');
                  print('$e');
                  print('@@@@@@ 끝 @@@@@@');
                  memberController.logout();
                }
              } else if (errorCode == 9000 ||
                  errorCode == 9001 ||
                  errorCode == 9003) {
                memberController.logout();
              }
              return handler.next(e);
            },
          ));
}

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoTokenUtil {
  Future<bool> validateKakaoToken() async {
    try{
      if (await AuthApi.instance.hasToken()) {
        try {
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          User user = await UserApi.instance.me();
          print('토큰id: ${tokenInfo.id}'
              '\n토큰유효기간: ${tokenInfo.expiresIn}'
              '\n유저번호: ${user.id}'
              '\n유저닉네임: ${user.kakaoAccount?.profile?.nickname}');
          return true;
        } catch (error) {
          if (error is KakaoException && error.isInvalidTokenError()) {
            print('토큰 만료 $error');
            return false;
          } else {
            print('토큰 정보 조회 실패 $error');
            return false;
          }
        }
      } else {
        print('발급된 토큰 없음');
        return false;
      }
    } catch (e){
      print('토큰 인증 실패');
      return false;
    }
  }
}
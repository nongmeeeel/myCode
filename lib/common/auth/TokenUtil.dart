import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtil {
  static const String BEARER = 'Bearer ';
  static final storage = FlutterSecureStorage();

  // Token 저장하기
  static Future<void> saveTokens(Headers headers) async {
    await storage.write(key: 'access-token', value: headers.value('access-token'));
    await storage.write(key: 'refresh-token', value: headers.value('refresh-token'));
  }

  // 저장된 Access Token 가져오기
  static Future<String?> getAccessToken() async {
    return await storage.read(key: 'access-token');
  }

  // 저장된 Refresh Token 가져오기
  static Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh-token');
  }

  // 디코딩된 Access Token 가져오기
  static Future<Map<String, dynamic>?> getDecodedAccessToken() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        return JwtDecoder.decode(token);
      }
    } catch (error) {
      print("Error decoding access token: $error");
    }
    return null;
  }

  // 디코딩된 Refresh Token 가져오기
  static Future<Map<String, dynamic>?> getDecodedRefreshToken() async {
    try {
      final token = await getRefreshToken();
      if (token != null) {
        return JwtDecoder.decode(token);
      }
    } catch (error) {
      print("Error decoding refresh token: $error");
    }
    return null;
  }

  // Access Token Header 가져오기
  static Future<String> getAccessTokenHeader() async {
    final token = await getAccessToken();
    return '$BEARER$token';
  }

  // Refresh Token Header 가져오기
  static Future<String> getRefreshTokenHeader() async {
    final token = await getRefreshToken();
    return '$BEARER$token';
  }

  // 로그인 상태 확인
  static Future<bool> isLogin() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    if (refreshToken != null && accessToken != null) {
      return !JwtDecoder.isExpired(refreshToken);
    }
    return false;
  }

  // 관리자인지 확인
  static Future<bool> isAdmin() async {
    final decodedAccessToken = await getDecodedAccessToken();
    return await isLogin() && decodedAccessToken?['role'] == 'ADMIN';
  }

  // VIP인지 확인
  static Future<bool> isVip() async {
    final decodedAccessToken = await getDecodedAccessToken();
    if (await isLogin() && decodedAccessToken != null) {
      final role = decodedAccessToken['role'];
      return ['ADMIN', 'VIP'].contains(role);
    }
    return false;
  }

  // MEMBER인지 확인
  static Future<bool> isMember() async {
    final decodedAccessToken = await getDecodedAccessToken();
    if (await isLogin() && decodedAccessToken != null) {
      final role = decodedAccessToken['role'];
      return ['ADMIN', 'VIP', 'MEMBER'].contains(role);
    }
    return false;
  }

  // 저장된 토큰 삭제하기
  static Future<void> removeTokens() async {
    await storage.delete(key: 'access-token');
    await storage.delete(key: 'refresh-token');
  }
}
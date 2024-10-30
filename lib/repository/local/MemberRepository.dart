import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mycode/common/BaseDio.dart';
import 'package:mycode/common/auth/TokenUtil.dart';
import '../../common/Interceptor.dart';
import '../../common/FunctionUtil.dart';
import '../../model/local/Member.dart';
import '../../model/local/UserTown.dart';
import '../../model/third_party/Town.dart';

class MemberRepository {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final Dio dio = BaseDio('/member').dio;

  Future<void> loginAPI(String username, String password) async {
    final Dio nomalDio = Dio();
    try {
      Response response = await nomalDio.post(
        'http://10.0.2.2:8080/login',
        data: {'username': username, 'password': password},
      );
      TokenUtil.saveTokens(response.headers);
      print("로그인 성공 및 토큰 저장 완료");
    } catch (e) {
      handleException(e);
    }
  }

  Future<List<Member>> fetchMemberListAPI() async {
    try {
      Response response = await dio.get('/list');
      List<dynamic> responseData = response.data;
      return responseData.map((json) => Member.fromJson(json)).toList();
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  Future<List<Member>> updateFilterAndSelectMemberListByMapAPI(Map<String, dynamic> data) async {
    try {
      Response response = await dio.put('/list/by-map', data: data);
      List<dynamic> responseData = response.data;
      return responseData.map((json) => Member.fromJson(json)).toList();
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  Future<void> updateMemberTownAPI(
      Town town, double lat, double lng, double zoom) async {
    try {
      await dio.put('/town', data: {
        'townCode': town.emdCd,
        'nm': town.emdKorNm,
        'fullNm': town.fullNm,
        'engNm': town.emdEngNm,
        'lat': lat,
        'lng': lng,
        'zoomLevel': zoom
      });
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> updateMemberCodeFilterMapAPI(List<int> itemIdList) async {
    try {
      await dio.put('/code/filter', data: itemIdList);
    } catch (e) {
      handleException(e);
    }
  }

  Future<Member?> fetchMemberAPI() async {
    try {
      Response response = await dio.get('/');
      dynamic responseData = response.data;
      return Member.fromJson(responseData);
    } catch (e) {
      handleException(e);
      return null;
    }
  }

// Future<void> insertTownTemp(UserTown userTown) async {
//   try{
//     Response response = await authDio.post(
//         '/user/town',
//         data: {
//           'townCode': userTown.townCode,
//           'nm': userTown.nm,
//           'fullNm': userTown.fullNm,
//           'engNm': userTown.engNm,
//           'lat': userTown.lat,
//           'lng': userTown.lng,
//           'zoomLevel': userTown.zoomLevel
//         }
//     );
//     if (response.statusCode == 201) {
//       print("등록 완료 : ${userTown.townCode}");
//     } else {
//       throw Exception(ResponseFailMessage(response));
//     }
//   } catch(e) {
//     throw Exception(e);
//   }
// }
}

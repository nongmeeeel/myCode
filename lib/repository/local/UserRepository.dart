import 'package:dio/dio.dart';
import '../../common/FunctionUtil.dart';
import '../../model/local/User.dart';
import '../../model/local/UserTown.dart';
import '../../model/third_party/Town.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<List<User>> getUserListAPI() async {
    try{
      Response response = await _dio.get('http://10.0.2.2:8080/api/v1/user/list');
      if(response.statusCode == 200){
        List<dynamic> responseData = response.data;
        return responseData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<User> getUser() async {
    try{
      Response response = await _dio.get('http://10.0.2.2:8080/api/v1/user/user');
      if(response.statusCode == 200){
        dynamic responseData = response.data;
        return User.fromJson(responseData);
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> updateUserTown(Town town, double lat, double lng, double zoom) async {
    try{
      Response response = await _dio.put(
          'http://10.0.2.2:8080/api/v1/user/town',
          data: {
            'townCode': town.emdCd,
            'nm': town.emdKorNm,
            'fullNm': town.fullNm,
            'engNm': town.emdEngNm,
            'lat': lat,
            'lng': lng,
            'zoomLevel': zoom
          }
      );
      if (response.statusCode == 204) {
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> insertTownTemp(UserTown userTown) async {
    try{
      Response response = await _dio.post(
          'http://10.0.2.2:8080/api/v1/user/town',
          data: {
            'townCode': userTown.townCode,
            'nm': userTown.nm,
            'fullNm': userTown.fullNm,
            'engNm': userTown.engNm,
            'lat': userTown.lat,
            'lng': userTown.lng,
            'zoomLevel': userTown.zoomLevel
          }
      );
      if (response.statusCode == 201) {
        print("등록 완료 : ${userTown.townCode}");
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch(e) {
      throw Exception(e);
    }
  }


}
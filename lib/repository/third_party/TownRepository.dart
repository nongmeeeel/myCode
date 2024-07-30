import 'dart:ffi';

import 'package:dio/dio.dart';

import '../../common/Interceptor.dart';
import '../../common/FunctionUtil.dart';
import '../../model/third_party/Town.dart';
import '../../model/third_party/TownOne.dart';

class TownRepository {
  final Dio dio = Dio();
  final Dio authDio = getAuthDio();
  final String vworldKey = '381D36EB-9CC0-3C62-9B77-13A5D78C2EAD';


  Future<List<Town>> selectTownListByTownNmAPI(String townNm) async {
    try{
      Response response = await authDio.get(
        'https://api.vworld.kr/req/data',
        queryParameters: {
          'service' : 'data',
          'version' : '2.0',
          'request' : 'GetFeature',
          'size' : '100',
          'page' : '1',
          'data' : 'LT_C_ADEMD_INFO',
          'attrfilter' : 'emd_kor_nm:like:${townNm}',
          'geometry' : 'false',
          // 'attribute' : 'false',
          // 'columns' : 'properties',
          // 'geomFilter' : 'POINT(x y)',
          // 'crs' : 'EPSG:4326',
          'key' : vworldKey,
        });

      switch (response.data['response']['status']) {
        case "NOT_FOUND":
        case "ERROR":
          return [];
        case "OK":
          final List<dynamic> responseData =
          response.data['response']['result']['featureCollection']['features'];
          return responseData.map((json) => Town.fromJson(json)).toList();
        default:
          throw Exception('Unknown status: ${response.data['response']['status']}');
      }
    } catch(e) {
      throw Exception(e);
    }
  }


  Future<TownOne> getTownByTownCodeAPI(String townCode) async {
    try{
      Response response = await authDio.get(
          'https://api.vworld.kr/req/data',
          queryParameters: {
            'service' : 'data',
            'version' : '2.0',
            'request' : 'GetFeature',
            'data' : 'LT_C_ADEMD_INFO',
            'attrfilter' : 'emdCd:=:${townCode}',
            // 'geometry' : 'false',
            // 'geomFilter' : 'POINT(x y)',
            // 'crs' : 'EPSG:4326',
            'key' : vworldKey,
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data['response']['result']['featureCollection'];
        return TownOne.fromJson(responseData);
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch(e, stackTrace) {
      throw Exception(e);
    }
  }
}

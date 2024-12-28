import 'package:dio/dio.dart';

import '../../common/FunctionUtil.dart';
import '../../model/third_party/Town.dart';

class TownRepository {
  final Dio dio = Dio();
  final String vworldKey = '4FC4ACF5-1D75-377D-A068-690FE9C7F339';

  Future<List<Town>> searchTownListByTownNmAPI(String townNm) async {
    try {
      Response response =
          await dio.get('https://api.vworld.kr/req/search', queryParameters: {
        'key': vworldKey,
        'query': townNm,
        'type': 'district',
        'category': 'L4',
        'request': 'search'
      });

      switch (response.data['response']['status']) {
        case "NOT_FOUND":
        case "ERROR":
          return [];
        case "OK":
          final List<dynamic> responseData =
              response.data['response']['result']['items'];
          return responseData.map((json) => Town.fromJson(json)).toList();
        default:
          throw Exception(
              'Unknown status: ${response.data['response']['status']}');
      }
    } catch (e) {
      handleException(e);
      throw Exception(e);
    }
  }

  // Future<TownOne> getTownByTownCodeAPI(String townCode) async {
  //   try {
  //     Response response =
  //         await dio.get('https://api.vworld.kr/req/data', queryParameters: {
  //       'service': 'data',
  //       'version': '2.0',
  //       'request': 'GetFeature',
  //       'data': 'LT_C_ADEMD_INFO',
  //       'attrfilter': 'emdCd:=:${townCode}',
  //       // 'geometry' : 'false',
  //       // 'geomFilter' : 'POINT(x y)',
  //       // 'crs' : 'EPSG:4326',
  //       'key': vworldKey,
  //     });
  //     final Map<String, dynamic> responseData =
  //         response.data['response']['result']['featureCollection'];
  //     return TownOne.fromJson(responseData);
  //   } catch (e, stackTrace) {
  //     handleException(e);
  //     throw Exception(e);
  //   }
  // }
}

import 'package:dio/dio.dart';

import '../../common/FunctionUtil.dart';
import '../../model/local/Code.dart';

class CodeRepository {
  final Dio _dio = Dio();

  Future<List<CodeType>> getAllCodeListAPI() async {
    try {
      Response response = await _dio.get('http://10.0.2.2:8080/api/v1/code/list');
      if (response.statusCode == 200) {
        List<CodeType> allCodeList = codeTypeFromJson(response.data);
        return allCodeList;
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> insertUserCodeFilterMapAPI(List<int> itemIdList) async {
    try {
      Response response = await _dio.post(
        'http://10.0.2.2:8080/api/v1/user/filter'
        ,data: itemIdList
        ,options: Options(
          headers: {
            'Content-Type': 'application/json', // JSON 형식으로 전송
          },
        ),
      );
      if (response.statusCode == 201) {
        print('Filters finserted successfully');
      } else {
        throw Exception(ResponseFailMessage(response));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
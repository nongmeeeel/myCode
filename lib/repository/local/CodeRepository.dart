import 'package:dio/dio.dart';

import '../../common/Interceptor.dart';
import '../../common/FunctionUtil.dart';
import '../../model/local/Code.dart';

class CodeRepository {
  final Dio dio = Dio();
  final Dio authDio = getAuthDio();

  Future<List<CodeType>> fetchAllCodeListAPI() async {
    try {
      Response response = await authDio.get('http://10.0.2.2:8080/api/v1/code/list');
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
      Response response = await authDio.post(
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
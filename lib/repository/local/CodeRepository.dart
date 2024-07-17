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
}
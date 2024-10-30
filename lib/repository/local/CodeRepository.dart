import 'package:dio/dio.dart';

import '../../common/BaseDio.dart';
import '../../common/Interceptor.dart';
import '../../common/FunctionUtil.dart';
import '../../model/local/Code.dart';

class CodeRepository {
  final Dio dio = BaseDio('/code').dio;

  Future<List<CodeType>> fetchAllCodeListAPI() async {
    try {
      Response response = await dio.get('/list');
      List<CodeType> allCodeList = codeTypeFromJson(response.data);
      return allCodeList;
    } catch (e) {
      handleException(e);
      throw Exception(e);
    }
  }
}

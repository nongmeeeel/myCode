import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mycode/common/BaseDio.dart';
import 'package:mycode/common/auth/TokenUtil.dart';
import 'package:mycode/model/local/request/SignUpRequestDTO.dart';
import '../../common/FunctionUtil.dart';
import '../../model/local/Member.dart';
import '../../model/local/response/FetchMemberResponseDTO.dart';
import '../../model/local/response/MemberCode.dart';
import '../../model/third_party/Town.dart';

class MemberRepository {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final Dio dio = BaseDio('/member').dio;

  // kakao login 확인 되면 -> 토큰 발급
  Future<void> loginAPI(String username, String password, String loginType,
      String nickname) async {
    final Dio nomalDio = Dio();
    try {
      Response response = await nomalDio.post(
        'http://10.0.2.2:8080/login',
        data: {
          'username': username,
          'password': password,
          'loginType': loginType,
          'nickname': nickname
        },
      );
      TokenUtil.saveTokens(response.headers);
      print("로그인 성공 및 토큰 저장 완료");
    } catch (e) {
      handleException(e);
    }
  }

  // 본인 Member정보 초기화
  Future<FetchMemberResponseDTO?> fetchMemberAPI() async {
    try {
      Response response = await dio.get('/fetch');
      dynamic responseData = response.data;
      return FetchMemberResponseDTO.fromJson(responseData);
    } catch (e) {
      handleException(e);
      return null;
    }
  }

  // member list 조회
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

  Future<List<FetchMemberResponseDTO>> selectMemberListByMapInfoAPI(
      Map<String, dynamic> data) async {
    try {
      Response response = await dio.get('/list/by-map', queryParameters: data);
      List<dynamic> responseData = response.data;
      return responseData
          .map((json) => FetchMemberResponseDTO.fromJson(json))
          .toList();
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  Future<void> updateMemberTownAPI(Town town) async {
    try {
      await dio.put('/town', data: town);
    } catch (e) {
      handleException(e);
    }
  }

  // Future<void> updateMemberCodeFilterMapAPI(List<int> itemIdList) async {
  //   try {
  //     await dio.put('/code/filter', data: itemIdList);
  //   } catch (e) {
  //     handleException(e);
  //   }
  // }

  Future<void> signUpAPI(SignUpRequestDTO signUpRequestDTO) async {
    try {
      Response response =
          await dio.put('/signup', data: signUpRequestDTO.toJson());
      TokenUtil.saveTokens(response.headers);
      print("로그인 성공 및 토큰 저장 완료");
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> updateMemberCodeMap(Set<int> codeItemIdSet) async {
    try {
      await dio.put('/code', data: List<int>.from(codeItemIdSet));
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> updateMemberCodeFilterMap(Set<int> codeItemIdSet) async {
    try {
      await dio.put('/code/filter', data: List<int>.from(codeItemIdSet));
    } catch (e) {
      handleException(e);
    }
  }

  Future<List<MemberCode>> selectMemberCodeList() async {
    try {
      Response response = await dio.get('/codes');
      List<dynamic> responseData = response.data;
      return responseData.map((item) => MemberCode.fromJson(item)).toList();
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  Future<List<MemberCode>> selectMemberCodeFilterList() async {
    try {
      Response response = await dio.get('/codes/filter');
      List<dynamic> responseData = response.data;
      return responseData.map((item) => MemberCode.fromJson(item)).toList();
    } catch (e) {
      handleException(e);
      return [];
    }
  }

  Future<Member?> updateMember(
      String name, String gender, String birthDate) async {
    try {
      Response response = await dio.put('/',
          data: {"name": name, "gender": gender, "birthDate": birthDate});
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

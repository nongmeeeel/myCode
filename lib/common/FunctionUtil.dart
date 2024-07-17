import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/third_party/TownOne.dart';

double townOneToZoomLevel(TownOne townOne) {

  double lengthX = townOne.bbox[2] - townOne.bbox[0];
  print("lenLength : $lengthX");
  if (lengthX < 0.005) {
    return 15.6;
  } else if (lengthX < 0.0075) {
    return 15.2;
  } else if (lengthX < 0.01) {
    return 14.8;
  } else if (lengthX < 0.0125) {
    return 14.4;
  } else if (lengthX < 0.015) {
    return 14.0;
  } else if (lengthX < 0.0175) {
    return 13.75;
  } else if (lengthX < 0.02) {
    return 13.5;
  } else if (lengthX < 0.0225) {
    return 13.25;
  } else if (lengthX < 0.025) {
    return 13.0;
  } else if (lengthX < 0.0275) {
    return 12.75;
  } else if (lengthX < 0.03) {
    return 12.5;
  } else if (lengthX < 0.05) {
    return 12.25;
  } else if (lengthX < 0.07) {
    return 12.0;
  } else if (lengthX < 0.08) {
    return 11.5;
  } else if (lengthX < 0.12) {
    return 11.0;
  } else if (lengthX < 0.16) {
    return 10.5;
  } else {
    return 10.0; // 더 넓게 보기 위해 축소
  }
}

List<double> townOneToCenterYX(TownOne townOne) {
  double Y = (townOne.bbox[1] + townOne.bbox[3]) / 2;
  double X = (townOne.bbox[0] + townOne.bbox[2]) / 2;
  return [Y, X];
}

String ResponseFailMessage (Response response) {
  return "------------ResponseError 코드: ${response.statusCode} 메시지: ${response.statusMessage}";
}



// void GlobalFlutterError(FlutterErrorDetails details) {
//   Get.snackbar(
//     'FlutterError 에러 발생',
//     details.exception.toString(),
//     snackPosition: SnackPosition.BOTTOM,
//   );
// }
//
// void GlobalRunZonedError(Object error, StackTrace stackTrace) {
//   Get.snackbar(
//     'RunZonedError 에러 발생 : ${error.toString()}',
//     "${stackTrace}",
//     snackPosition: SnackPosition.BOTTOM,
//   );
// }
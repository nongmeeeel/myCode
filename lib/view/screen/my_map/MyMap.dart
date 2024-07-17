import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mycode/common/FunctionUtil.dart';

import '../../../model/third_party/Town.dart';
import '../../../model/third_party/TownOne.dart';
import '../../../service/TownController.dart';
import '../../../service/UserController.dart';

class MyMap extends StatelessWidget {
  MyMap ({this.userTown});
  final TownOne? userTown;

  @override
  Widget build(BuildContext context) {
    return userTown == null ? DefaultTown() : UserTown(userTown: userTown);
  }
}


class UserTown extends StatelessWidget {
  UserTown({required this.userTown});
  final TownOne? userTown;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    double centerY = userController.centerY.value;
    double centerX = userController.centerX.value;
    double zoomLevel = userController.zoomLevel.value;

    Set<NPolygonOverlay> NPolygonOverlaySet = {};
    if ( userTown != null) {
      final List<List<List<List<double>>>> coordinates = userTown!
          .features[0].geometry.coordinates;
      for (int i = 0; i < coordinates.length; i++) {
        List<NLatLng> coords = (coordinates[i][0].map((e) =>
            NLatLng(e[1], e[0])).toList());
        NPolygonOverlaySet.add(
            createNPolygonOverlay(coords: coords, id: "coords${i}"));
      }
    }

    return Container(
      color: Colors.blue, // Just a placeholder color
      child: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(centerY,centerX),
            zoom: zoomLevel,
            bearing: 0,
            tilt: 0
          ),
        ), // 지도 옵션을 설정할 수 있습니다.
        forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
        onMapReady: (controller) async {
          controller.addOverlayAll(NPolygonOverlaySet);
        },
        onMapTapped: (point, latLng) {},
        onSymbolTapped: (symbol) {},
        onCameraChange: (position, reason) {},
        onCameraIdle: () {},
        onSelectedIndoorChanged: (indoor) {},
      )
    );
  }
}


class DefaultTown extends StatelessWidget {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    double centerY = userController.centerY.value;
    double centerX = userController.centerX.value;
    double zoomLevel = userController.zoomLevel.value;

    return Container(
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
                target: NLatLng(centerY,centerX),
                zoom: zoomLevel,
                bearing: 0,
                tilt: 0
            ),
          ),  // 지도 옵션을 설정할 수 있습니다.
          forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
          onMapReady: (controller) async {},
          onMapTapped: (point, latLng) {},
          onSymbolTapped: (symbol) {},
          onCameraChange: (position, reason) {},
          onCameraIdle: () async {},
          onSelectedIndoorChanged: (indoor) {},
        )
    );
  }
}

// NPolygonOverlay 가공
NPolygonOverlay createNPolygonOverlay({
  required String id,
  required List<NLatLng> coords,
}) {
  return NPolygonOverlay(
    id: id,
    coords: coords,
    outlineColor: Colors.blue, // 다각형의 테두리 색상 설정
    color: Colors.blue.withOpacity(0.3), // 다각형의 내부 영역 색상 설정
    outlineWidth: 2, // 다각형의 테두리 선의 너비 설정
  );
}

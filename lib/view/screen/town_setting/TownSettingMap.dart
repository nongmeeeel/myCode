import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';

import '../../../model/local/MemberTown.dart';
import '../../../service/MemberController.dart';

class TownSettingMap extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();
  NaverMapController? nController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MemberTown memberTown = memberController.memberTown.value!;
      if (nController != null) {
        NLatLng nLatLng = NLatLng(memberTown.y, memberTown.x);
        NCameraPosition position = NCameraPosition(target: nLatLng, zoom: 12);
        NCameraUpdate updateCameraInfo =
            NCameraUpdate.fromCameraPosition(position);
        nController!.updateCamera(updateCameraInfo);
      }

      return Container(
          color: Colors.blue, // Just a placeholder color
          child: NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(memberTown.y, memberTown.x),
                  zoom: 13,
                  bearing: 0,
                  tilt: 0),
            ), // 지도 옵션을 설정할 수 있습니다.
            forceGesture:
                false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
            onMapReady: (controller) async {
              nController = controller;
            },
            onCameraIdle: () async {
              // 화면 전환 시 화면에 포함된 user 검색 (현재 사용 불필요)
              if (nController != null) {
                // nController가 null이 아닐 때만 호출
                _addCircleOverlay(nController!, memberTown);
              }
            },
          ));
    });
  }
}

// member 동네 위치 Circle 출력
void _addCircleOverlay(NaverMapController controller, MemberTown memberTown) {
  NCircleOverlay circle = NCircleOverlay(
    id: 'circle_1', // 고유 ID 설정
    center: NLatLng(memberTown.y, memberTown.x),
    radius: 500, // 반지름을 원하는 값으로 설정 (미터 단위)
    color: Colors.red.withOpacity(0.5), // 원의 색상과 투명도 설정
    outlineColor: Colors.red,
    outlineWidth: 2,
  );

  controller.addOverlay(circle);
}

// NPolygonOverlay 가공
// NPolygonOverlay createNPolygonOverlay({
//   required String id,
//   required List<NLatLng> coords,
// }) {
//   return NPolygonOverlay(
//     id: id,
//     coords: coords,
//     outlineColor: Colors.blue, // 다각형의 테두리 색상 설정
//     color: Colors.blue.withOpacity(0.3), // 다각형의 내부 영역 색상 설정
//     outlineWidth: 2, // 다각형의 테두리 선의 너비 설정
//   );
// }

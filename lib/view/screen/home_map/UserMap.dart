import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../model/local/User.dart';
import '../../../model/third_party/TownOne.dart';
import '../../../service/UserController.dart';
import 'CodeFilterList.dart';

class UserMap extends StatelessWidget {
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final TownOne userTown = userController.userTown.value!;
    double centerY = userController.centerY.value;
    double centerX = userController.centerX.value;
    double zoomLevel = userController.zoomLevel.value;
    List<User> userList = userController.userList.value;

    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
                target: NLatLng(centerY,centerX),
                zoom: zoomLevel,
                bearing: 0,
                tilt: 0
            ),
          ),
          forceGesture: false,
          onMapReady: (controller) {
            _addPolygonOverlay(controller, userTown);
            // controller.addOverlayAll(NPolygonOverlaySet);
            _addOverlayAll(controller, userList);
            _addCircleOverlays(controller, userList, context);
            _addCircleOverlays2(controller, userList, context);
          },
          onMapTapped: (point, latLng) {},
          onSymbolTapped: (symbol) {},
          onCameraChange: (position, reason) {},
          onCameraIdle: () {},
          onSelectedIndoorChanged: (indoor) {},
        ),
        // 지도 위에 리스트를 겹쳐 출력
        CodeFilterList()
      ],
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

void _addOverlayAll(NaverMapController controller, List<User> userList) {
  Map<String, List<User>> userGroupMap = {};
  for (User user in userList) {
    String townCode = user.userTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(user);
  }

  Map<String, Set<NAddableOverlay>> overlaysMap = {};

  var index = 0;
  userGroupMap.forEach((townCode, users) {
    Set<NAddableOverlay> markers = {};
    for (var user in users) {
      index++;
      markers.add(NMarker(
        id: "$index",
        position: NLatLng(user.userTown.lat, user.userTown.lng),
        icon: NOverlayImage.fromAssetImage('assets/images/marker.png'),
        size: Size(40.0, 40.0),
      ));
    }
    overlaysMap[townCode] = markers;
  });

  controller.addOverlayAll(overlaysMap['41135106']!);
  var a = 1;

}



// 내 위치 영역 Polygon 출력
void _addPolygonOverlay(NaverMapController controller, TownOne userTown) {
  Set<NPolygonOverlay> NPolygonOverlaySet = {};
  if ( userTown != null) {
    final List<List<List<List<double>>>> coordinates = userTown
        .features[0].geometry.coordinates;
    for (int i = 0; i < coordinates.length; i++) {
      List<NLatLng> coords = (coordinates[i][0].map((e) =>
          NLatLng(e[1], e[0])).toList());
      NPolygonOverlaySet.add(
          createNPolygonOverlay(coords: coords, id: "coords${i}"));
    }
  }
  controller.addOverlayAll(NPolygonOverlaySet);
}



// userList 동네 위치 Circle 출력
void _addCircleOverlays(NaverMapController controller, List<User> userList, BuildContext context) {
  Map<String, List<User>> userGroupMap = {};

  for (User user in userList) {
    String townCode = user.userTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(user);
  }

  int index = 0;

  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      User firstUser = users.first;
      NCircleOverlay circle = NCircleOverlay(
        id: 'circle_$index', // 고유 ID 설정
        center: NLatLng(firstUser.userTown.lat, firstUser.userTown.lng),
        radius: 500, // 반지름을 원하는 값으로 설정 (미터 단위)
        color: Colors.red.withOpacity(0.5), // 원의 색상과 투명도 설정
        outlineColor: Colors.red,
        outlineWidth: 2,
      );

      circle.setOnTapListener((overlay) {
        _showUserListBottomSheet(context, users);
      });

      controller.addOverlay(circle);
      index++;
    }
  });
}

// 동네 위치 이름 및 custom이미지 출력
void _addCircleOverlays2(NaverMapController controller, List<User> userList, BuildContext context) {
  Map<String, List<User>> userGroupMap = {};

  for (User user in userList) {
    String townCode = user.userTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(user);
  }

  int index = 0;

  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      User firstUser = users.first;

      // 투명 아이콘으로 마커 오버레이 생성 (글자 가독성 확보)
      NMarker marker = NMarker(
        id: 'marker_$index',
        position: NLatLng(firstUser.userTown.lat, firstUser.userTown.lng),
        icon: NOverlayImage.fromAssetImage('assets/images/girl1.png'),
        size: Size(40.0,40.0),
        caption: NOverlayCaption(text: "${firstUser.userTown.nm}"),
        subCaption: NOverlayCaption(text: "${users.length}"),
        // label: NLabel(
        //   text: '${firstUser.userTown.townName}',
        //   color: Colors.black,
        //   fontSize: 16,
        //   offset: Offset(0, -20),
        // ),
      );

      marker.setOnTapListener((overlay) {
        _showUserListBottomSheet(context, users);
      });

      controller.addOverlay(marker);
      index++;
    }
  });
}

void _showUserListBottomSheet(BuildContext context, List<User> users) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                // backgroundImage: NetworkImage(users[index].profileImage),
                backgroundImage: AssetImage('assets/images/minji.jpg'),

                radius: 25.0, // 프로필 사진의 크기 설정
              ),
              title: Text(users[index].name),
              subtitle: Text(users[index].gender),
            );
          },
        ),
      );
    },
  );
}
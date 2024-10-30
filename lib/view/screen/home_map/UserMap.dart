import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../model/local/Member.dart';
import '../../../model/third_party/TownOne.dart';
import '../../../service/MemberController.dart';
import 'CodeFilterList.dart';

class UserMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MemberController memberController = Get.find<MemberController>();

    return Obx((){
      TownOne? userTown = memberController.memberTown.value;
      List<Member> memberList = memberController.memberList.value;

      return userTown != null && memberList.isNotEmpty ? ActiveMap() : DefaultMap();
    });
  }
}

class DefaultMap extends StatelessWidget {
  MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    List<Member> userList = memberController.memberList.value;

    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: NCameraPosition(
                target: NLatLng(37.3946,127.1107),
                zoom: 14.4,
                bearing: 0,
                tilt: 0
            ),
          ),
          forceGesture: false,
          onMapReady: (controller) {
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
      ],
    );
  }
}


class ActiveMap extends StatelessWidget {
  MemberController memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    List<Member> userList = memberController.memberList.value ;
    TownOne userTown = memberController.memberTown.value!;
    double centerY = memberController.centerY.value;
    double centerX = memberController.centerX.value;
    double zoomLevel = memberController.zoomLevel.value;

    NaverMapController? nController;

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
            nController = controller;
            _addPolygonOverlay(controller, userTown);
            // _addOverlayAll(controller, userList);
            _addCircleOverlays(controller, userList, context);
            _addCircleOverlays2(controller, userList, context);
          },
          onMapTapped: (point, latLng) {},
          onSymbolTapped: (symbol) {},
          onCameraChange: (position, reason) {},
          onCameraIdle: () async {
              // 화면 전환 시 화면에 포함된 user 검색 (현재 사용 불필요)
              if (nController != null) { // nController가 null이 아닐 때만 호출
                NLatLngBounds nContentBounds = await nController!.getContentBounds();
                memberController.setBounds(nContentBounds);
              }
            },
          onSelectedIndoorChanged: (indoor) {},
        ),
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

void _addOverlayAll(NaverMapController controller, List<Member> memberList) {
  Map<String, List<Member>> userGroupMap = {};
  for (Member member in memberList) {
    String townCode = member.memberTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(member);
  }

  Map<String, Set<NAddableOverlay>> overlaysMap = {};

  var index = 0;
  userGroupMap.forEach((townCode, users) {
    Set<NAddableOverlay> markers = {};
    for (var user in users) {
      index++;
      markers.add(NMarker(
        id: "$index",
        position: NLatLng(user.memberTown.lat, user.memberTown.lng),
        icon: NOverlayImage.fromAssetImage('assets/images/marker.png'),
        size: Size(40.0, 40.0),
      ));
    }
    overlaysMap[townCode] = markers;
  });

  controller.addOverlayAll(overlaysMap['41135106']!);
}



// 내 위치 영역 Polygon 출력
void _addPolygonOverlay(NaverMapController controller, TownOne userTown) {
  Set<NPolygonOverlay> NPolygonOverlaySet = {};

  final List<List<List<List<double>>>> coordinates = userTown
      .features[0].geometry.coordinates;
  for (int i = 0; i < coordinates.length; i++) {
    List<NLatLng> coords = (coordinates[i][0].map((e) =>
        NLatLng(e[1], e[0])).toList());
    NPolygonOverlaySet.add(
        createNPolygonOverlay(coords: coords, id: "coords${i}"));
  }

  controller.addOverlayAll(NPolygonOverlaySet);
}



// userList 동네 위치 Circle 출력
void _addCircleOverlays(NaverMapController controller, List<Member> memberList, BuildContext context) {
  Map<String, List<Member>> userGroupMap = {};

  for (Member member in memberList) {
    String townCode = member.memberTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(member);
  }

  int index = 0;

  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      Member firstUser = users.first;
      NCircleOverlay circle = NCircleOverlay(
        id: 'circle_$index', // 고유 ID 설정
        center: NLatLng(firstUser.memberTown.lat, firstUser.memberTown.lng),
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

// userList 동네이름, 유저수, custom이미지 출력
void _addCircleOverlays2(NaverMapController controller, List<Member> userList, BuildContext context) {
  Map<String, List<Member>> userGroupMap = {};

  for (Member user in userList) {
    String townCode = user.memberTown.townCode;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(user);
  }

  int index = 0;

  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      Member firstUser = users.first;

      // 투명 아이콘으로 마커 오버레이 생성 (글자 가독성 확보)
      NMarker marker = NMarker(
        id: 'marker_$index',
        position: NLatLng(firstUser.memberTown.lat, firstUser.memberTown.lng),
        icon: NOverlayImage.fromAssetImage('assets/images/girl1.png'),
        size: Size(40.0,40.0),
        caption: NOverlayCaption(text: "${firstUser.memberTown.nm}"),
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

void _showUserListBottomSheet(BuildContext context, List<Member> users) {
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
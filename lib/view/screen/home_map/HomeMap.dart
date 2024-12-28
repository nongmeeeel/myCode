import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/MapInfo.dart';
import 'package:mycode/service/ChatController.dart';

import '../../../model/local/Member.dart';
import '../../../model/local/MemberTown.dart';
import '../../../service/MemberController.dart';

class MemberMap extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();
  // NaverMapController? nController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MemberTown memberTown = memberController.memberTown.value!;

      NaverMapController? nController = memberController.nController.value;

      if (nController != null) {
        NLatLng nLatLng = NLatLng(memberTown.y, memberTown.x);
        NCameraPosition position = NCameraPosition(target: nLatLng, zoom: 12);
        NCameraUpdate updateCameraInfo =
            NCameraUpdate.fromCameraPosition(position);
        nController.updateCamera(updateCameraInfo);
      }

      return NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
              target: NLatLng(memberTown.y, memberTown.x),
              zoom: 13,
              bearing: 0,
              tilt: 0),
        ),
        forceGesture: false,
        onMapReady: (controller) {
          memberController.nController.value = controller;
        },
        onMapTapped: (point, latLng) {},
        onSymbolTapped: (symbol) {},
        onCameraChange: (position, reason) {},
        onCameraIdle: () async {
          // 화면 전환 시 화면에 포함된 user 검색 (현재 사용 불필요)
          if (nController != null) {
            // nController가 null이 아닐 때만 호출
            MapInfo mapInfo = memberController.mapInfo.value!;
            NLatLngBounds bounds = await nController.getContentBounds();
            if (bounds.northEast.latitude == mapInfo.eastLat &&
                bounds.northEast.longitude == mapInfo.eastLng &&
                bounds.southWest.latitude == mapInfo.westLat &&
                bounds.southWest.longitude == mapInfo.westLng) {
            } else {
              memberController.setMapInfo(bounds);
              List<Member> selectMemberListByMapInfo =
                  await memberController.selectMemberListByMapInfo();
              _addCircleOverlays(
                  nController, selectMemberListByMapInfo, context);
              _addMemberListOverlays(
                  nController, selectMemberListByMapInfo, context);
            }
          }
        },
        onSelectedIndoorChanged: (indoor) {},
      );
    });
  }
}

// 내 위치 영역 Polygon 출력
// void _addPolygonOverlay(NaverMapController controller, Town memberTown) {
//   Set<NPolygonOverlay> NPolygonOverlaySet = {};
//
//   final List<List<List<List<double>>>> coordinates = memberTown
//       .features[0].geometry.coordinates;
//   for (int i = 0; i < coordinates.length; i++) {
//     List<NLatLng> coords = (coordinates[i][0].map((e) =>
//         NLatLng(e[1], e[0])).toList());
//     NPolygonOverlaySet.add(
//         createNPolygonOverlay(coords: coords, id: "coords${i}"));
//   }
//
//   controller.addOverlayAll(NPolygonOverlaySet);
// }

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

// memberList 동네 위치 Circle 출력
void _addCircleOverlays(NaverMapController controller, List<Member> memberList,
    BuildContext context) {
  Map<String, List<Member>> userGroupMap = {};

  for (Member member in memberList) {
    String townCode = member.memberTown.id;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(member);
  }

  int index = 0;

  controller.clearOverlays();
  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      Member firstUser = users.first;
      NCircleOverlay circle = NCircleOverlay(
        id: 'circle_$index', // 고유 ID 설정
        center: NLatLng(firstUser.memberTown.y, firstUser.memberTown.x),
        radius: 500, // 반지름을 원하는 값으로 설정 (미터 단위)
        color: Colors.red.withOpacity(0.4), // 원의 색상과 투명도 설정
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

// memberList 동네이름, 유저수, custom이미지 출력
void _addMemberListOverlays(NaverMapController controller,
    List<Member> memberList, BuildContext context) {
  Map<String, List<Member>> userGroupMap = {};

  for (Member user in memberList) {
    String townCode = user.memberTown.id;
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
        position: NLatLng(firstUser.memberTown.y, firstUser.memberTown.x),
        icon: NOverlayImage.fromAssetImage('assets/images/girl1.png'),
        size: Size(40.0, 40.0),
        caption: NOverlayCaption(
            text: "${firstUser.memberTown.title.split(' ').last}"),
        subCaption: NOverlayCaption(text: "${users.length}"),
        // label: NLabel(
        //   text: '${firstUser.memberTown.townName}',
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

// 해당 지역 유저 리스트 정보 BOTTOM SHEET 세팅
void _showUserListBottomSheet(BuildContext context, List<Member> users) {
  ChatController _chatController = Get.find();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/minji.jpg'),
                radius: 25.0, // 프로필 사진의 크기 설정
              ),
              title: Text(
                users[index].name,
                style: TextStyle(
                  fontSize: 20.0, // 이름 크기 크게 설정
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    users[index].gender,
                    style: TextStyle(
                      fontSize: 14.0, // 성별 크기 설정
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    users[index].birthDate, // 생년월일 추가
                    style: TextStyle(
                      fontSize: 14.0, // 생년월일 크기 설정
                    ),
                  ),
                ],
              ),
              onTap: () {
                _chatController.createDirectChatRoom(users[index]);
              },
              // trailing: _buildChipItem(users[index].), // 오른쪽에 code 표시
            );
          },
        ),
      );
    },
  );
}

Widget _buildChipItem(String text) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF3E566F),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFCCCCCB),
      ),
    ),
  );
}

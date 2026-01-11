import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:mycode/model/local/MapInfo.dart';
import 'package:mycode/model/local/response/FetchMemberResponseDTO.dart';
import 'package:mycode/service/ChatController.dart';

import '../../../model/local/Member.dart';
import '../../../model/local/MemberTown.dart';
import '../../../service/MemberController.dart';

class MemberMap extends StatelessWidget {
  final MemberController memberController = Get.find<MemberController>();
  final isInitialized = false.obs; // 초기화 상태 추적

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MemberTown memberTown = memberController.memberTown.value!;
      List<FetchMemberResponseDTO> mapMembers =
          memberController.mapMemberList; // 현재 맵 멤버 리스트

      NaverMapController? nController = memberController.nController.value;

      if (nController != null) {
        // 최초 한 번만 카메라 위치 설정
        if (!isInitialized.value) {
          NLatLng nLatLng = NLatLng(memberTown.y, memberTown.x);
          NCameraPosition position = NCameraPosition(target: nLatLng, zoom: 12);
          NCameraUpdate updateCameraInfo =
              NCameraUpdate.fromCameraPosition(position);
          nController.updateCamera(updateCameraInfo);
          isInitialized.value = true;
        }

        // 오버레이 업데이트
        _addCircleOverlays(nController, mapMembers, context);
        _addMemberListOverlays(nController, mapMembers, context);
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
          if (nController != null) {
            MapInfo mapInfo = memberController.mapInfo.value!;
            NLatLngBounds bounds = await nController.getContentBounds();
            if (bounds.northEast.latitude != mapInfo.eastLat ||
                bounds.northEast.longitude != mapInfo.eastLng ||
                bounds.southWest.latitude != mapInfo.westLat ||
                bounds.southWest.longitude != mapInfo.westLng) {
              memberController.setMapInfo(bounds);
              memberController.selectMemberListByMapInfo(); // 결과를 직접 사용하지 않음
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
void _addCircleOverlays(NaverMapController controller,
    List<FetchMemberResponseDTO> fetchMemberList, BuildContext context) {
  Map<String, List<Member>> userGroupMap = {};

  List<Member> memberList = fetchMemberList.map((e) => e.member).toList();

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
        _showUserListBottomSheet(context, fetchMemberList);
      });

      controller.addOverlay(circle);
      index++;
    }
  });
}

// memberList 동네이름, 유저수, custom이미지 출력
void _addMemberListOverlays(NaverMapController controller,
    List<FetchMemberResponseDTO> fetchMemberList, BuildContext context) {
  Map<String, List<FetchMemberResponseDTO>> userGroupMap = {};

  for (FetchMemberResponseDTO user in fetchMemberList) {
    Member member = user.member;
    String townCode = member.memberTown.id;
    if (!userGroupMap.containsKey(townCode)) {
      userGroupMap[townCode] = [];
    }
    userGroupMap[townCode]!.add(user);
  }

  int index = 0;

  userGroupMap.forEach((townCode, users) {
    if (users.isNotEmpty) {
      FetchMemberResponseDTO firstUser = users.first;

      // 투명 아이콘으로 마커 오버레이 생성 (글자 가독성 확보)
      NMarker marker = NMarker(
        id: 'marker_$index',
        position: NLatLng(
            firstUser.member.memberTown.y, firstUser.member.memberTown.x),
        icon: NOverlayImage.fromAssetImage('assets/images/girl1.png'),
        size: Size(40.0, 40.0),
        caption: NOverlayCaption(
            text: "${firstUser.member.memberTown.title.split(' ').last}"),
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
void _showUserListBottomSheet(
    BuildContext context, List<FetchMemberResponseDTO> users) {
  ChatController _chatController = Get.find();

  // 나이 계산 함수
  int calculateAge(String birthDate) {
    final year = int.parse(birthDate.substring(0, 4));
    final currentYear = DateTime.now().year;
    return currentYear - year;
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final member = users[index].member;
            final codeItems = users[index].memberCodeList;
            final age = calculateAge(member.birthDate);

            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/minji.jpg'),
                radius: 25.0,
              ),
              title: Row(
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${member.gender} • ${age}세',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              subtitle: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: codeItems
                      .map((code) => Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Chip(
                              label: Text(code.codeItemTitle),
                              labelStyle: TextStyle(fontSize: 12),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                            ),
                          ))
                      .toList(),
                ),
              ),
              onTap: () {
                _chatController.createDirectChatRoom(member);
              },
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mycode/service/MemberController.dart';
import '../../../service/CodeController.dart';

class CodeFilterWidget extends StatelessWidget {
  final CodeController _codeController = Get.find<CodeController>();
  final MemberController _memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 필터 버튼
          ElevatedButton.icon(
            onPressed: () {
              Set<int> codeFilterItemIdSet = _memberController
                  .memberCodeFilterList
                  .map((element) => element!.codeItemId)
                  .toSet();
              _codeController.setSelectedFilterItemSet(codeFilterItemIdSet);
              Get.toNamed('/setting/code/filter');
            },
            icon: Icon(Icons.filter_list),
            label: Text('필터'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(width: 8),

          // 선택된 필터 항목들
          Expanded(
            child: Obx(() {
              final selectedItems = _codeController.selectedFilterItemSet;
              if (selectedItems.isEmpty) {
                return Text('선택된 필터 없음', style: TextStyle(color: Colors.grey));
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _codeController.allCodeItemList
                      .where((item) => selectedItems.contains(item.id))
                      .map((item) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(item.title),
                              onDeleted: () {
                                _codeController.toggleFilterItemSelect(item.id);
                              },
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // void _showFilterDialog(BuildContext context) async {
  //   // 현재 선택된 항목들 임시 저장
  //   final tempSelected = <int>{...(_codeController.selectedItemIdSet)}.obs;

  //   await Get.dialog(
  //     AlertDialog(
  //       title: Text('관심사 필터'),
  //       content: Container(
  //         width: double.maxFinite,
  //         height: MediaQuery.of(context).size.height * 0.6,
  //         child: SingleChildScrollView(
  //           child: Wrap(
  //             spacing: 8,
  //             runSpacing: 8,
  //             children: _codeController.allCodeItemList.map((item) {
  //               return Obx(() {
  //                 final isSelected = tempSelected.contains(item.id);
  //                 return FilterChip(
  //                   label: Text(item.title),
  //                   selected: isSelected,
  //                   onSelected: (selected) {
  //                     if (selected) {
  //                       tempSelected.add(item.id);
  //                     } else {
  //                       tempSelected.remove(item.id);
  //                     }
  //                   },
  //                 );
  //               });
  //             }).toList(),
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text('취소'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // 선택 항목 저장
  //             _codeController.selectedItemIdSet.value = tempSelected;
  //             Get.back();
  //           },
  //           child: Text('적용'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

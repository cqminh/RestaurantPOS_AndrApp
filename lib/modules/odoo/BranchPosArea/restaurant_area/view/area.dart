import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/widgets/customWidget.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/controller/area_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/repository/area_record.dart';

class AreaDropdown extends StatelessWidget {
  const AreaDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    AreaController areaController = Get.find<AreaController>();

    RxList<AreaRecord> viewArea = [AreaRecord.publicArea()].obs;
    viewArea.addAll(areaController.areafilters);

    return Container(
      alignment: Alignment.center,
      height: Get.height * 0.1,
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
      child: Obx(() {
          return CustomMiniWidget.searchAndChooseButton(
              title: 'Danh sách khu vực của POS',
              hint: 'Tất cả',
              items: viewArea
                  .map((area) => DropdownMenuItem(
                        value: area,
                        child: Text(area.name),
                      ))
                  .toList(),
              value: viewArea.firstWhereOrNull(
                  (element) => element.id == areaController.area.value.id),
              onChanged: (area) {
                if (area != null) {
                  areaController.area.value = area;
                  Get.find<AreaController>().onChangedAreas(area.id);
                }
              });
        }
      ),
    );
  }
}

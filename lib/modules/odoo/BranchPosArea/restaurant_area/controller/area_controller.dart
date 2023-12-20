import 'package:get/get.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/repository/area_record.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';

class AreaController extends GetxController {
  RxList<AreaRecord> areas = <AreaRecord>[].obs;
  RxList<AreaRecord> areafilters = <AreaRecord>[].obs;
  Rx<AreaRecord> area = AreaRecord.publicArea().obs;

  void clearArea() {
    area = AreaRecord.publicArea().obs;
  }

  void clear() {
    areas = <AreaRecord>[].obs;
    areafilters = <AreaRecord>[].obs;
    area = AreaRecord.publicArea().obs;
  }

  // ?: Thay đổi khu vực khi chọn trong dropdown
  void onChangedAreas(int value) async {
    AreaRecord? areaf = Get.find<AreaController>()
        .areafilters
        .firstWhereOrNull((element) => element.id == value);
    areaf != null
        ? Get.find<AreaController>().area.value = areaf
        : Get.find<AreaController>().clearArea();
    Get.find<TableController>().filter(
      areaf != null ? [area.value.id] : null,
      [Get.find<PosController>().pos.value.id],
    );
    update();
  }

  // filter area
  void filter(List<int> posIds) {
    List<AreaRecord> listFilter = areas.where((p0) {
      if (p0.pos_ids != null && p0.pos_ids!.isNotEmpty) {
        List<dynamic>? posId = p0.pos_ids;
        List<int> idList = posId!.map((item) => item as int).toList();
        return idList.any((value) => posIds.contains(value));
      }
      return false;
    }).toList();
    areafilters.clear();
    areafilters.addAll(listFilter);
    update();
  }

  List<TableRecord> filtertable(AreaRecord areaId, PosRecord posId) {
    List<TableRecord> table =
        Get.find<TableController>().tablefilters.where((p0) {
      if (p0.area_id != null &&
          p0.area_id!.isNotEmpty &&
          p0.pos_id != null &&
          p0.pos_id!.isNotEmpty) {
        return p0.area_id?[0] == areaId.id && p0.pos_id?[0] == posId.id;
      }
      return false;
    }).toList();

    return table;
  }

  // int counttable(AreaRecord areaid, PosRecord posId) {
  //   List<TableRecord> table =
  //       Get.find<TableController>().tablefilters.where((p0) {
  //     if (p0.area_id != null &&
  //         p0.area_id!.isNotEmpty &&
  //         p0.pos_id != null &&
  //         p0.pos_id!.isNotEmpty) {
  //       return p0.area_id?[0] == areaid.id && p0.pos_id?[0] == posId.id;
  //     }
  //     return false;
  //   }).toList();
  //   return table.length;
  // }

  // int counttableWithStatus(AreaRecord areaid, PosRecord posId, String status) {
  //   List<TableRecord> table =
  //       Get.find<TableController>().tablefilters.where((p0) {
  //     if (p0.area_id != null &&
  //         p0.area_id!.isNotEmpty &&
  //         p0.pos_id != null &&
  //         p0.pos_id!.isNotEmpty) {
  //       return p0.area_id?[0] == areaid.id &&
  //           p0.pos_id?[0] == posId.id &&
  //           p0.status == status;
  //     }
  //     return false;
  //   }).toList();
  //   return table.length;
  // }
}

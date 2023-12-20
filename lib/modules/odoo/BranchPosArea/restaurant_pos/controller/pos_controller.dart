import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/controller/area_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';

class PosController extends GetxController {
  RxList<PosRecord> pose = <PosRecord>[].obs;
  RxList<PosRecord> poseFilters = <PosRecord>[].obs;
  Rx<PosRecord> pos = PosRecord.publicPos().obs;

  void clear() {
    pose = <PosRecord>[].obs;
    poseFilters = <PosRecord>[].obs;
    pos = PosRecord.publicPos().obs;
  }

  Future changePos(PosRecord value) async {
    HomeController homeController = Get.find<HomeController>();
    try {
      if (Get.find<PosController>().pos.value.id != value.id) {
        Get.find<PosController>().pos.value = value;
        homeController.statusSave.value = true;
        // do đã có data rồi thì không fetch về nữa
        // AREA
        // MainController.to.env.of<AreaRepository>().domain = [
        //   ['company_id', '=', Get.find<HomeController>().companyUser.value.id],
        //   [
        //     'hotel_restaurant_pos_ids',
        //     'in',
        //     [Get.find<PosController>().pos.value.id]
        //   ]
        // ];
        // await Get.find<MainController>()
        //     .env
        //     .of<AreaRepository>()
        //     .fetchRecords();
        // Get.find<AreaController>().areas.clear();
        // Get.find<AreaController>().areas.value = Get.find<MainController>()
        //     .env
        //     .of<AreaRepository>()
        //     .latestRecords
        //     .toList();
        // Get.find<AreaController>().areafilters.clear();
        // Get.find<AreaController>().areafilters.value =
        //     Get.find<MainController>()
        //         .env
        //         .of<AreaRepository>()
        //         .latestRecords
        //         .toList();

        Get.find<AreaController>().filter([pos.value.id]);
        Get.find<AreaController>().clearArea();

        // NOTE: Lấy tất cả các bàn
        // await Get.find<TableController>().fetchTable(null, [
        //   [
        //     'pos_hotel_restaurant_id',
        //     '=',
        //     Get.find<PosController>().pos.value.id
        //   ]
        // ]);

        Get.find<TableController>().filter(null, [pos.value.id]);
        update();
        homeController.statusSave.value = false;
      }
    } catch (e) {
      log("$e changePos");
    }
  }
}

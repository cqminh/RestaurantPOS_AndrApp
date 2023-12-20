import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Inventory/stock_move/controller/stock_move_controller.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/repository/stock_picking_record.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/repository/stock_picking_repos.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';

class StockPickingController extends GetxController {
  RxList<StockPickingRecord> stockpickingFilters = <StockPickingRecord>[].obs;

  Future<void> validateStockPicking(SaleOrderRecord order) async {
    log("validateStockPicking");
    // List<dynamic> proList =
    //     Get.find<ProductTemplateController>().productValiDate;
    StockPickingRepository stockPickingRepo =
        StockPickingRepository(Get.find<MainController>().env);
    stockPickingRepo.domain = [
      [
        'state',
        'not in',
        ['done', 'cancel']
      ],
      ['sale_id', '=', order.id]
    ];
    await stockPickingRepo.fetchRecords();
    stockpickingFilters.clear();
    stockpickingFilters.value = stockPickingRepo.latestRecords.toList();
    update();

    // log("$stockpickingFilters");
    OdooEnvironment env = Get.find<MainController>().env;
    StockPickingRepository stockPickingRepository = StockPickingRepository(env);

    for (StockPickingRecord i in stockpickingFilters) {
      await Get.find<StockMoveController>()
          .checkValiDate(i)
          .then((value) async {
        if (value == true) {
          if (i.origin == order.name) {
            await stockPickingRepository.valiDate(i.id);
          } else {
            await stockPickingRepository.valiDateReturn(i.id);
          }
        }
      });
    }
    log("DONE");
  }
}
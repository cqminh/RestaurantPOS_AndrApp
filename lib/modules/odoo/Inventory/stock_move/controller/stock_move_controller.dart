import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Inventory/stock_move/repository/stock_move_record.dart';
import 'package:test/modules/odoo/Inventory/stock_move/repository/stock_move_repos.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/repository/stock_picking_record.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';

class StockMoveController extends GetxController {
  ProductTemplateController productTemplateController =
      Get.find<ProductTemplateController>();
  RxList<StockMoveRecord> stockmoveFilters = <StockMoveRecord>[].obs;

  Future<bool> checkValiDate(StockPickingRecord stockpicking) async {
    // log("checkValiDate");
    List<int> proList = productTemplateController.productValiDate
        .map((item) => item[0] as int)
        .toList();
    StockMoveRepository stockmoveRepo =
        StockMoveRepository(Get.find<MainController>().env);
    stockmoveRepo.domain = [
      [
        'state',
        'not in',
        ['done', 'cancel']
      ],
      ['picking_id', '=', stockpicking.id],
      ['product_id', 'in', proList],
    ];
    await stockmoveRepo.fetchRecords();
    stockmoveFilters.clear();
    stockmoveFilters.value = stockmoveRepo.latestRecords.toList();
    update();
    // ignore: invalid_use_of_protected_member
    if (stockmoveFilters.value.isNotEmpty) {
      // ignore: invalid_use_of_protected_member, unused_local_variable
      for (StockMoveRecord i in stockmoveFilters.value) {
        if (i.quantity_done != null) {
          log("es es as ${i.quantity_done}");
          if (i.quantity_done! > 0) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
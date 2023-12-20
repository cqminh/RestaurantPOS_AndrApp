// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_repos.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_repos.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_repos.dart';

class SaleOrderLineController extends GetxController {
  RxList<SaleOrderLineRecord> saleorderlines = <SaleOrderLineRecord>[].obs;
  RxList<SaleOrderLineRecord> saleorderlinesold = <SaleOrderLineRecord>[].obs;
  Rx<SaleOrderLineRecord> saleOrderLine = SaleOrderLineRecord.publicSaleOrderLine().obs;

  void clear() {
    List<dynamic>? order_id = saleOrderLine.value.order_id;
    saleOrderLine = SaleOrderLineRecord.publicSaleOrderLine().obs;
    saleOrderLine.value.order_id = order_id;
    update();
  }

  Future<void> createOrWriteSaleOrderLine(bool fetch) async {
    try {
      OdooEnvironment env = Get.find<MainController>().env;
      List<SaleOrderLineRecord> createOredit = [];
      List<Map<String, dynamic>> re_new = <Map<String, dynamic>>[];
      List<Map<String, dynamic>> re_old = <Map<String, dynamic>>[];
      for (SaleOrderLineRecord line in saleorderlines) {
        if (line.id > 0) {
          SaleOrderLineRecord? old = saleorderlinesold
              .firstWhereOrNull((element) => element.id == line.id);
          if (line.product_uom_qty != old?.product_uom_qty ||
              line.qty_reserved != old?.qty_reserved ||
              line.remarks != old?.remarks) {
            re_new.add({
              'id': line.id,
              'product_uom_qty': line.product_uom_qty != old?.product_uom_qty
                  ? line.product_uom_qty
                  : null,
              'qty_reserved': line.qty_reserved == old?.qty_reserved
                  ? null
                  : line.qty_reserved,
              'remarks': line.remarks == old?.remarks ? null : line.remarks,
            });
            re_old.add({
              'id': old?.id,
              'product_uom_qty': old?.product_uom_qty,
              'qty_reserved': old?.qty_reserved,
              'remarks': old?.remarks,
            });
            Map<String, dynamic>? result_new = {
              'id': line.id,
              'product_uom_qty': line.product_uom_qty != old?.product_uom_qty
                  ? line.product_uom_qty
                  : null,
              'qty_reserved': line.qty_reserved == old?.qty_reserved
                  ? null
                  : line.qty_reserved,
              'remarks': line.remarks == old?.remarks ? null : line.remarks,
            };
            Map<String, dynamic>? result_old = {
              'id': old?.id,
              'product_uom_qty': old?.product_uom_qty,
              'qty_reserved': old?.qty_reserved,
              'remarks': line.remarks == old?.remarks ? null : line.remarks,
            };
            if (result_old['product_uom_qty'] != null &&
                result_new['product_uom_qty'] != null &&
                result_old['qty_reserved'] != null) {
              if (result_old['product_uom_qty'] >
                      result_new['product_uom_qty'] &&
                  result_new['product_uom_qty'] < result_old['qty_reserved']) {
                line.product_uom_qty = result_old['product_uom_qty'];
              }
            }
            createOredit.add(line);
          }
        } else {
          if (line.id == 0) {
            createOredit.add(line);
          }
        }
      }
      if (createOredit.isNotEmpty) {
        await env
            .of<SaleOrderRepository>()
            .editLine(
                id: Get.find<SaleOrderController>().saleOrderRecord.value.id,
                lines: createOredit)
            .then((result) {
          // for (Map<String, dynamic> resu in result) {
          //   if (resu.containsKey('qty_reserved')) {
          //     Get.find<ProductTemplateController>().productValiDate.add(
          //         resu['id'] > 0
          //             ? saleorderlineFilters
          //                 .firstWhereOrNull(
          //                     (element) => element.id == resu['id'])
          //                 ?.product_id
          //             : resu['product_id']);
          //   }
          // }
        });
      }
      List<SaleOrderLineRecord> edit1 = [];
      List<SaleOrderLineRecord> edit2 = [];
      for (SaleOrderLineRecord line in saleorderlines) {
        double update = 0.0;
        if (line.id > 0) {
          Map<String, dynamic>? result_new = re_new.firstWhereOrNull((element) {
            return element['id'] == line.id;
          });
          Map<String, dynamic>? result_old = re_old.firstWhereOrNull((element) {
            return element['id'] == line.id;
          });
          bool check = false;
          if (result_new != null && result_old != null) {
            if (result_old['qty_reserved'] != null &&
                result_new['qty_reserved'] != null &&
                result_new['qty_reserved'] > 0) {
              if (result_old['qty_reserved'] > result_new['qty_reserved']) {
                update =
                    result_old['qty_reserved'] - result_new['qty_reserved'];
              }
            }
            if (result_new['product_uom_qty'] != null &&
                result_old['product_uom_qty'] != null &&
                result_old['qty_reserved'] != null) {
              if (result_old['product_uom_qty'] >
                      result_new['product_uom_qty'] &&
                  result_new['product_uom_qty'] < result_old['qty_reserved']) {
                line.product_uom_qty = result_new['product_uom_qty'];
                check = true;
              }
            }
            if (update > 0) {
              line.product_uom_qty = line.product_uom_qty! + update;
              edit1.add(line);
              line.product_uom_qty = line.product_uom_qty! - update;
              check = true;
            }
            if (check == true) {
              edit2.add(line);
            }
          }
        }
      }
      if (edit1.isNotEmpty) {
        await env.of<SaleOrderRepository>().editLine(
            id: Get.find<SaleOrderController>().saleOrderRecord.value.id,
            lines: edit1);
      }
      if (edit2.isNotEmpty) {
        await env.of<SaleOrderRepository>().editLine(
            id: Get.find<SaleOrderController>().saleOrderRecord.value.id,
            lines: edit2);
      }
      // clear data
      TableController tableController = Get.find<TableController>();
      if (fetch) {
        await Get.find<SaleOrderController>()
            .getSaleOrder(tableController.table.value, true, false);
      } else {
        OdooEnvironment env = Get.find<MainController>().env;
        TableRepository tableRepo = TableRepository(env);
        tableRepo.domain = [
          ['id', '=', tableController.table.value.id]
        ];
        await tableRepo.fetchRecords();
        tableController.table.value =
            tableRepo.latestRecords.firstWhereOrNull((element) => true) ??
                TableRecord.publicTable();
        TableRecord? tableRecord = tableController.tables.firstWhereOrNull(
            (element) => element.id == tableController.table.value.id);
        if (tableRecord?.status != tableController.table.value.status) {
          tableController.tables
              .firstWhere(
                  (element) => element.id == tableController.table.value.id)
              .status = tableController.table.value.status;
          tableController.tablefilters
              .firstWhere(
                  (element) => element.id == tableController.table.value.id)
              .status = tableController.table.value.status;
        }
      }
    } catch (e) {
      log("$e", name: "createOrwriteSaleOrderLine on sale order");
    }
  }

  Future<bool> fetchRecordsSaleOrderLine(int orderId, bool edit) async {
    bool check = false;
    OdooEnvironment env = Get.find<MainController>().env;
    SaleOrderLineRepository saleOrderLineRepo = SaleOrderLineRepository(env);
    saleOrderLineRepo.domain = [
      ['order_id', '=', orderId],
      ['product_uom_qty', '>', '0']
    ];
    await saleOrderLineRepo.fetchRecords();
    if (edit) {
      for (SaleOrderLineRecord line
          in saleOrderLineRepo.latestRecords.toList()) {
        var temp = saleorderlinesold.firstWhereOrNull((element) {
          return element.id == line.id;
        });
        // Chỉ ghi đè những line bị thay đổi đồng thời
        // những line thêm mới hoặc edit từ một phía thì cập nhật bình thường
        // if (temp == null) {
        //   saleorderlines.add(line);
        // } else {
        //   if (temp.id != line.id ||
        //       temp.remarks != line.remarks ||
        //       temp.product_uom_qty != line.product_uom_qty ||
        //       temp.qty_reserved != line.qty_reserved) {
        //     saleorderlines.removeWhere((element) {
        //       return element.id == line.id;
        //     });
        //     saleorderlines.add(line);
        //     saleorderlinesold.removeWhere((element) {
        //       return element.id == line.id;
        //     });
        //     var cloneRecord = SaleOrderLineRecord.fromJson(line.toJson());
        //     saleorderlinesold.add(cloneRecord);
        //   }
        // }

        // chỉ cần trên service thay đổi sẽ ghi đè lên
        if (temp != null) {
          if (temp.remarks != line.remarks ||
              temp.product_uom_qty != line.product_uom_qty ||
              temp.qty_reserved != line.qty_reserved) {
            saleorderlines.clear();
            saleorderlines.addAll(saleOrderLineRepo.latestRecords.toList());
            saleorderlinesold.clear();
            for (var record in saleorderlines) {
              var cloneRecord = SaleOrderLineRecord.fromJson(record.toJson());
              saleorderlinesold.add(cloneRecord);
            }
            check = true;
            break;
          }
        }
      }
    } else {
      saleorderlines.clear();
      saleorderlines.addAll(saleOrderLineRepo.latestRecords.toList());
      saleorderlinesold.clear();
      for (var record in saleorderlines) {
        var cloneRecord = SaleOrderLineRecord.fromJson(record.toJson());
        saleorderlinesold.add(cloneRecord);
      }
    }
    update();
    return check;
  }
}

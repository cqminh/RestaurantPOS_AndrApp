import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/controller/branch_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Customer/res_partner/controller/partner_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_repos.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_repos.dart';

class SaleOrderController extends GetxController {
  Rx<SaleOrderRecord> saleOrderRecord = SaleOrderRecord.publicSaleOrder().obs;

  Future<bool> getSaleOrder(
      TableRecord table, bool fetchtable, bool editline) async {
    bool check = false;
    // NOTE: Nếu chọn bàn không trống
    TableController tableController = Get.find<TableController>();
    if (fetchtable) {
      OdooEnvironment env = Get.find<MainController>().env;
      TableRepository tableRepo = TableRepository(env);
      tableRepo.domain = [
        ['id', '=', table.id]
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
    } else {
      tableController.table.value = table;
    }
    if (tableController.table.value.id > 0) {
      if (tableController.table.value.status == "occupied") {
        await fetchSaleOrder(null, table.id);
        check = await Get.find<SaleOrderLineController>()
            .fetchRecordsSaleOrderLine(saleOrderRecord.value.id, editline);
      } else {
        Get.find<SaleOrderLineController>().saleorderlines.clear();
        Get.find<SaleOrderLineController>().clear();
        saleOrderRecord.value =
            SaleOrderRecord.publicSaleOrderRestaurant().obs.value;
        saleOrderRecord.value.table_id = [
          tableController.table.value.id,
          tableController.table.value.name
        ];
        saleOrderRecord.value.id = 0;
        saleOrderRecord.value.company_id = [
          Get.find<HomeController>().companyUser.value.id,
          Get.find<HomeController>().companyUser.value.name
        ];
        saleOrderRecord.value.pos_id = [
          Get.find<PosController>().pos.value.id,
          Get.find<PosController>().pos.value.name
        ];
        saleOrderRecord.value.partner_id_hr =
            Get.find<PosController>()
                .pos
                .value
                .customer_default_id;
        if (Get.find<ResPartnerController>().partners.firstWhereOrNull(
                (element) =>
                    element.id == saleOrderRecord.value.partner_id_hr?[0]) !=
            null) {
          saleOrderRecord.value.pricelist_id = Get.find<ResPartnerController>()
              .partners
              .firstWhereOrNull((element) =>
                  element.id == saleOrderRecord.value.partner_id_hr?[0])!
              .property_product_pricelist;
        }
        saleOrderRecord.value.warehouse_id =
            Get.find<BranchController>()
                .branchFilters[0]
                .warehouse_id;
      }
    }
    update();
    return check;
  }

  Future<void> createSaleOrder(bool fetch) async {
    try {
      OdooEnvironment env = Get.find<MainController>().env;
      SaleOrderRepository saleOrderRepository = SaleOrderRepository(env);
      SaleOrderLineController saleOrderLineController =
          Get.find<SaleOrderLineController>();
      TableController tableController = Get.find<TableController>();
      await env
          .of<SaleOrderRepository>()
          .create(saleOrderRecord.value)
          .then((value) async {
        // gán lại order_id cho sale.order.line
        log("create value $value");
        for (SaleOrderLineRecord line
            in saleOrderLineController.saleorderlines) {
          line.order_id = [
            saleOrderRecord.value.id,
            saleOrderRecord.value.name
          ];
        }
        // tạo sale order line
        await saleOrderLineController.createOrWriteSaleOrderLine(false);
        // confirm
        await saleOrderRepository.confirmOrder(value.id);

        if (fetch) {
          await Get.find<SaleOrderController>().getSaleOrder(
              tableController.table.value, true, false);
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
        // log("create $value");
      }).catchError((error) {
        log("er sale order $error");
      });
    } catch (e) {
      log("$e", name: "SaleOrderController createSaleOrder");
    }
  }

  Future<void> writeSaleOrder(int id, bool fetch) async {
    try {
      OdooEnvironment env = Get.find<MainController>().env;
      env.of<SaleOrderRepository>().domain = [
        ['id', '=', saleOrderRecord.value.id]
      ];
      await env.of<SaleOrderRepository>().fetchRecords();
      await env
          .of<SaleOrderRepository>()
          .write(saleOrderRecord.value)
          .then((value) async {
        log("write sale order $value");
        if (fetch) {
          await fetchSaleOrder(id, null);
        }
      }).catchError((error) {
        log("er write sale order $error");
      });
    } catch (e) {
      log("$e", name: "SaleOrderController writeSaleOrder");
    }
  }

  void clear() {
    saleOrderRecord = SaleOrderRecord.publicSaleOrder().obs;
    update();
  }

  Future<void> fetchSaleOrder(int? id, int? table) async {
    OdooEnvironment env = Get.find<MainController>().env;
    SaleOrderRepository saleOrderRepo = SaleOrderRepository(env);
    saleOrderRepo.domain = [
      id != null ? ['id', '=', id] : ['table_id', '=', table],
      [
        'state',
        'in',
        ['sale']
      ]
    ];
    await saleOrderRepo.fetchRecords();
    saleOrderRecord.value =
        saleOrderRepo.latestRecords.firstWhereOrNull((element) => true) ??
            SaleOrderRecord.publicSaleOrder();
    update();
  }
}

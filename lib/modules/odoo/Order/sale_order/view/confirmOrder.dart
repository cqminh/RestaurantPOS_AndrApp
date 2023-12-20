import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';

class ConfirmSaveOrder {
  Future confirmDialog() async {
    Get.dialog(
      CustomDialog.dialogMessage(
          exitButton: false,
          title: 'Cảnh báo',
          content: 'Bạn đã thay đổi đơn hàng, bạn có muốn lưu lại?',
          actions: [
            CustomDialog.popUpButton(
                child: Text(
                  'Huỷ',
                  style: AppFont.Body_Regular(),
                ),
                color: AppColors.dismissColor,
                onTap: () {
                  Get.find<HomeController>().statusSave.value = true;
                  Get.back();
                  Get.find<TableController>().table.value =
                      TableRecord.publicTable();
                  Get.find<SaleOrderController>().saleOrderRecord.value =
                      SaleOrderRecord.publicSaleOrder();
                  Get.find<SaleOrderLineController>().saleOrderLine.value =
                      SaleOrderLineRecord.publicSaleOrderLine();
                  Get.find<SaleOrderLineController>().saleorderlines.clear();
                  Get.find<HomeController>().statusSave.value = false;
                }),
            CustomDialog.popUpButton(
                child: Text(
                  'Đồng ý',
                  style: AppFont.Body_Regular(color: AppColors.white),
                ),
                color: AppColors.acceptColor,
                onTap: () async {
                  SaleOrderController saleOrderController =
                      Get.find<SaleOrderController>();
                  SaleOrderLineController saleOrderLineController =
                      Get.find<SaleOrderLineController>();
                  Get.find<HomeController>().statusSave.value = true;
                  Get.back();
                  if (saleOrderController.saleOrderRecord.value.id >= 0) {
                    if (saleOrderController.saleOrderRecord.value.id == 0) {
                      if (saleOrderLineController.saleorderlines.isNotEmpty) {
                        await saleOrderController.createSaleOrder(false);
                      } else {
                        CustomDialog.snackbar(
                          title: 'Thông báo',
                          message: 'Bạn chưa thêm sản phẩm',
                        );
                      }
                    } else {
                      await saleOrderController.writeSaleOrder(
                          saleOrderController.saleOrderRecord.value.id, false);
                      log("start ${DateTime.now()}");
                      await saleOrderLineController
                          .createOrWriteSaleOrderLine(false);
                      log("end ${DateTime.now()}");
                    }
                  }
                  Get.find<TableController>().table.value =
                      TableRecord.publicTable();
                  Get.find<SaleOrderController>().saleOrderRecord.value =
                      SaleOrderRecord.publicSaleOrder();
                  Get.find<SaleOrderLineController>().saleOrderLine.value =
                      SaleOrderLineRecord.publicSaleOrderLine();
                  Get.find<SaleOrderLineController>().saleorderlines.clear();
                  Get.find<HomeController>().statusSave.value = false;
                }),
          ]),
      barrierDismissible: false,
    );
  }
}

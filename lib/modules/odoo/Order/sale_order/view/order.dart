import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/utils/tools.dart';
import 'package:test/common/widgets/customWidget.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Customer/res_partner/controller/partner_controller.dart';
import 'package:test/modules/odoo/Customer/res_partner/repository/partner_record.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/view/order_line.dart';
import 'package:test/modules/odoo/Product/pos_category/controller/category_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/screens/loading.dart';

class SaleOrderView extends StatelessWidget {
  const SaleOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        child: Get.find<HomeController>().status.value == 3
            ? Scaffold(
                body: Center(
                    child: Text(
                "Lỗi ứng dụng, liên hệ Nhà phát triển.",
                style: AppFont.Body_Regular(color: AppColors.titleTextField),
              )))
            : !Get.find<HomeController>().statusSave.value &&
                    Get.find<HomeController>().status.value == 2
                ? Obx(() {
                    return Scaffold(
                      appBar: buildAppBar(),
                      body: buildBodyOrder(),
                      bottomNavigationBar: buildBottomOrder(),
                    );
                  })
                : const LoadingPage(),
        onWillPop: () async {
          Get.back();
          Get.find<MainController>().currentRoute.value = Get.currentRoute;
          return true;
        },
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.mainColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.white,
        ),
        onPressed: () {
          Get.back();
          Get.find<MainController>().currentRoute.value = Get.currentRoute;
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Get.find<TableController>().table.value.name}',
            style: AppFont.Title_H6_Bold(color: AppColors.white),
          ),
          Text(
            Get.find<TableController>().table.value.area_id?[1] ?? '',
            style: AppFont.Body_Regular(color: AppColors.white),
          ),
        ],
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () async {
      //       await Get.find<HomeController>().reLoad();
      //     },
      //     icon: const Icon(
      //       Icons.cloud_sync,
      //       color: Colors.white,
      //     ),
      //   )
      // ],
    );
  }

  Widget buildBodyOrder() {
    ResPartnerController resPartnerController =
        Get.find<ResPartnerController>();
    SaleOrderController saleOrderController = Get.find<SaleOrderController>();

    List<ResPartnerRecord> listPartner = resPartnerController.partners.toList();
    // Tìm khách hàng có priceList là tiền Việt (id == 2)
    List<ResPartnerRecord> choosablePartner = listPartner
        .where((element) => element.property_product_pricelist?[0] == 2)
        .toList();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: CustomMiniWidget.searchAndChooseButton(
              title: 'Khách hàng',
              hint: 'Chọn khách hàng',
              items: choosablePartner
                  .map((partner) => DropdownMenuItem(
                      value: partner, child: Text(partner.name.toString())))
                  .toList(),
              value: choosablePartner.firstWhereOrNull((element) =>
                  element.id ==
                  saleOrderController.saleOrderRecord.value.partner_id_hr?[0]),
              onChanged: (partner) {
                saleOrderController.saleOrderRecord.value.partner_id_hr = [
                  partner!.id,
                  partner.name
                ];
              },
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          Container(
            child: CustomMiniWidget.textFieldWithTitle(
                title: 'Ghi chú tổng',
                hint: 'Nhập ghi chú',
                controller: TextEditingController(
                    text: Tools.removeTagHtml(Get.find<SaleOrderController>()
                        .saleOrderRecord
                        .value
                        .note)),
                onChanged: (value) {
                  Get.find<SaleOrderController>().saleOrderRecord.value.note =
                      value;
                  Get.find<SaleOrderController>().update();
                }),
          ),
          const Expanded(
            child: SaleOrderLineView(),
          ),
        ],
      ),
    );
  }

  Widget buildBottomOrder() {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: Get.height * 0.1,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: Get.width * 0.05),
            color: AppColors.bgLight,
            height: Get.height * 0.04,
            child: Text(
              'Tổng tiền: ${Tools.doubleToVND((Get.find<SaleOrderController>().saleOrderRecord.value.amount_total ?? 0.0))}đ',
              style: AppFont.Body_Regular(size: 16),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CustomMiniWidget.paymentButton(
                    name: 'Gọi món',
                    onTap: () {
                      Get.toNamed("/product_template");
                      Get.find<MainController>().currentRoute.value =
                          Get.currentRoute;
                      Get.find<PosCategoryController>().parentCategory.clear();
                      Get.find<PosCategoryController>().filter(
                          null, [Get.find<PosController>().pos.value.id], true);
                    }),
                CustomMiniWidget.paymentButton(
                  name: 'Lưu',
                  color: AppColors.mainColor,
                  onTap: () async {
                    SaleOrderController saleOrderController =
                        Get.find<SaleOrderController>();
                    SaleOrderLineController saleOrderLineController =
                        Get.find<SaleOrderLineController>();
                    Get.find<HomeController>().statusSave.value = true;
                    if (saleOrderController.saleOrderRecord.value.id >= 0) {
                      if (saleOrderController.saleOrderRecord.value.id == 0) {
                        if (saleOrderLineController.saleorderlines.isNotEmpty) {
                          await saleOrderController.createSaleOrder(true);
                        } else {
                          CustomDialog.snackbar(
                            title: 'Thông báo',
                            message: 'Bạn chưa thêm sản phẩm',
                          );
                        }
                      } else {
                        await saleOrderController.writeSaleOrder(
                            saleOrderController.saleOrderRecord.value.id,
                            false);
                        log("start ${DateTime.now()}");
                        await saleOrderLineController
                            .createOrWriteSaleOrderLine(true);
                        log("end ${DateTime.now()}");
                      }
                    }
                    Get.find<HomeController>().statusSave.value = false;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

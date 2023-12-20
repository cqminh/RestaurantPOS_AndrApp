import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';

class TableList extends StatelessWidget {
  const TableList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Obx(() {
        return Get.find<TableController>().tablefilters.isEmpty
            ? Center(
                child: Text(
                  'Hiện tại ở khu vực này không có bàn',
                  style: AppFont.Body_Regular(color: AppColors.titleTextField),
                ),
              )
            : GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: Get.width * 0.03,
                  mainAxisSpacing: Get.width * 0.03,
                ),
                itemCount: Get.find<TableController>().tablefilters.length,
                itemBuilder: (context, index) {
                  TableRecord table =
                      Get.find<TableController>().tablefilters[index];
                  return buildTable(
                    onTap: () async {
                      Get.find<HomeController>().statusSave.value = true;
                      Get.toNamed("/sale_order");
                      Get.find<MainController>().currentRoute.value =
                          Get.currentRoute;
                      await Get.find<SaleOrderController>()
                          .getSaleOrder(table, true, false);
                      Get.find<HomeController>().statusSave.value = false;
                    },
                    table: table,
                  );
                },
              );
      }),
    );
  }

  Widget buildTable({TableRecord? table, Function()? onTap}) {
    Color? color = table?.status == 'available'
        ? AppColors.bgLight
        : table?.status == 'occupied'
            ? AppColors.occupiedColor
            : AppColors.errorColor;

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.1,
            width: Get.width * 0.3,
            decoration: BoxDecoration(
                color: color,
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                table?.name ?? 'table',
                style: AppFont.Body_Regular(),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: Get.height * 0.03,
              width: Get.height * 0.03,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.capacityColor,
              ),
              child: Center(
                child: Text(
                  '${table?.capacity ?? 0}',
                  style: AppFont.Body_Regular(color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

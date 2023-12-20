import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/utils/tools.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';

class SaleOrderLineView extends StatelessWidget {
  const SaleOrderLineView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaleOrderLineController>(builder: (controller) {
      return controller.saleorderlines.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: 8, left: Get.width * 0.01, right: Get.width * 0.01),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.saleorderlines.length,
                  itemBuilder: (context, index) {
                    SaleOrderLineRecord line = controller.saleorderlines[index];
                    return buildOrderLine(line: line, index: index);
                  },
                ),
              ),
            )
          : Center(
              child: Text(
                'Hiện tại đơn hàng đang trống!',
                style: AppFont.Body_Regular(color: AppColors.titleTextField),
              ),
            );
    });
  }

  Widget buildOrderLine({SaleOrderLineRecord? line, int? index}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
          ),
          alignment: Alignment.center,
          height: Get.height * 0.08,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // if (line!.id == 0) {
                  // Get.find<SaleOrderLineController>()
                  //     .saleorderlines
                  //     .removeAt(index!);
                  // Get.find<SaleOrderLineController>().update();
                  // } else {
                  //   Get.snackbar(
                  //     'Thông báo',
                  //     'Bạn không thể xóa',
                  //     colorText: const Color.fromARGB(255, 71, 6, 1),
                  //     maxWidth: Get.width * 0.5,
                  //     backgroundColor: const Color(0xffFFFBE6),
                  //   );
                  // }
                  line!.product_uom_qty = 0;
                  Get.find<SaleOrderLineController>().update();
                },
                icon: Icon(
                  Icons.delete,
                  color: AppColors.iconColor,
                ),
              ),
              SizedBox(
                width: Get.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line?.product_id?[1].substring(
                              line.product_id?[1].indexOf("]") + 1) ??
                          '',
                      overflow: TextOverflow.ellipsis,
                      style: AppFont.Title_H6_Bold(size: 13),
                    ),
                    Text(
                      '${Tools.doubleToVND(line?.price_unit)}đ/${line?.product_uom?[1] ?? ''}',
                      style: AppFont.Title_TF_Regular(),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                width: Get.width * 0.3,
                child: buildQtyTextField(line: line),
              ),
              IconButton(
                onPressed: () {
                  callNotePopUp(line: line);
                },
                icon: Icon(
                  Icons.edit,
                  color: AppColors.iconColor,
                ),
              ),
            ],
          ),
        ),
        line?.remarks == null || line?.remarks == ''
            ? SizedBox(height: Get.height * 0.01)
            : Container(
                margin: EdgeInsets.only(bottom: Get.height * 0.01),
                padding: const EdgeInsets.all(5),
                height: Get.height * 0.04,
                color: AppColors.bgLight,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ghi chú: ${line!.remarks}',
                  style: AppFont.Body_Italic(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      ],
    );
  }

  Widget buildQtyTextField({SaleOrderLineRecord? line}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildMinusPlusButton(
          isMinus: true,
          onTap: () {
            // SaleOrderLineRecord? old = Get.find<SaleOrderLineController>()
            //     .saleorderlinesold
            //     .firstWhereOrNull((element) => element.id == line!.id);
            // if (old == null ||
            //     ((line!.product_uom_qty ?? 0) - 1) -
            //             (old.product_uom_qty ?? 0) >=
            //         0) {
            line!.product_uom_qty = (line.product_uom_qty ?? 0) - 1 > 0
                ? line.product_uom_qty! - 1
                : 0;
            // } else {
            //   Get.snackbar(
            //     'Thông báo',
            //     'Bạn không thể giảm SL',
            //     colorText: const Color.fromARGB(255, 71, 6, 1),
            //     maxWidth: Get.width * 0.5,
            //     backgroundColor: const Color(0xffFFFBE6),
            //   );
            // }
            Get.find<SaleOrderLineController>().saleorderlines.removeWhere(
                (element) => element.id == 0 && element.product_uom_qty == 0);
            Get.find<SaleOrderLineController>().update();
          },
        ),
        SizedBox(
          width: Get.width * 0.1,
          child: TextField(
            controller:
                TextEditingController(text: '${line?.product_uom_qty ?? 0.0}'),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              value = value == '' ? '0.0' : value;
              var parsedValue = double.tryParse(
                  value.startsWith('.') == true ? '0$value' : value);

              SaleOrderLineRecord? check = Get.find<SaleOrderLineController>()
                  .saleorderlinesold
                  .firstWhereOrNull((element) => element.id == line?.id);
              if (check == null ||
                  check.product_uom_qty != null &&
                      parsedValue != null &&
                      check.product_uom_qty! <= parsedValue) {
                line?.product_uom_qty = parsedValue;
              } else {
                line?.product_uom_qty = check.product_uom_qty;
                CustomDialog.snackbar(
                  title: 'Thông báo',
                  message:
                      'Bạn không thể giảm SL nhỏ hơn ${check.product_uom_qty}',
                );
              }
              Get.find<SaleOrderLineController>().saleorderlines.removeWhere(
                  (element) => element.id == 0 && element.product_uom_qty == 0);
              Get.find<SaleOrderLineController>().update();
            },
          ),
        ),
        buildMinusPlusButton(onTap: () {
          line!.product_uom_qty = line.product_uom_qty! + 1;
          Get.find<SaleOrderLineController>().update();
        }),
      ],
    );
  }

  Widget buildMinusPlusButton(
      {bool? isMinus, Function()? onTap, Color? color, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: color ?? AppColors.bgDark,
        ),
        child: isMinus == true
            ? Icon(
                Icons.remove,
                color: iconColor ?? AppColors.white,
              )
            : Icon(
                Icons.add,
                color: iconColor ?? AppColors.white,
              ),
      ),
    );
  }

  void callNotePopUp({SaleOrderLineRecord? line}) {
    String? remarks;
    Get.dialog(
      CustomDialog.dialogWidget(
        title: 'Thêm ghi chú',
        content: Container(
          height: Get.height * 0.2,
          width: Get.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: TextEditingController(text: line?.remarks ?? ''),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Nhập ghi chú',
                hintStyle:
                    AppFont.Body_Regular(color: AppColors.placeholderText)),
            maxLines: null,
            onChanged: (value) {
              remarks = value;
            },
          ),
        ),
        actions: [
          CustomDialog.popUpButton(
            color: AppColors.acceptColor,
            child: Text(
              'Xác nhận',
              style: AppFont.Body_Regular(color: AppColors.white),
            ),
            onTap: () {
              line!.remarks = remarks;
              Get.find<SaleOrderLineController>().update();
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}

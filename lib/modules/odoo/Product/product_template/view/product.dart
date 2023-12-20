import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/utils/tools.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Product/pos_category/view/category.dart';
import 'package:test/modules/odoo/Product/product_product/controller/product_product_controller.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';

class ProductTemplateView extends StatelessWidget {
  const ProductTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(),
          body: Column(
            children: [
              const PosCategoryView(),
              Expanded(child: buildProductList()),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        Get.back();
        Get.find<MainController>().currentRoute.value = Get.currentRoute;
        return true;
      },
    );
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
      title: Text(
        'Danh sách sản phẩm',
        style: AppFont.Title_H6_Bold(color: AppColors.white),
      ),
    );
  }

  Widget buildProductList() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GetBuilder<ProductTemplateController>(
        builder: (controller) {
          return Get.find<ProductTemplateController>().productSearchs.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: Get.find<ProductTemplateController>()
                      .productSearchs
                      .length,
                  itemBuilder: (context, index) {
                    return buildProduct(
                      productTemplate: Get.find<ProductTemplateController>()
                          .productSearchs[index],
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Danh sách sản phẩm trống!',
                    style: AppFont.Title_TF_Regular(),
                  ),
                );
        },
      ),
    );
  }

  Widget buildProduct({ProductTemplateRecord? productTemplate}) {
    double? lst_price = Get.find<ProductProductController>()
        .productproductFilters
        .firstWhereOrNull(
            (e) => e.id == productTemplate?.product_variant_id?[0])
        ?.lst_price;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      height: Get.height * 0.08,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Get.width * 0.15,
            child: productTemplate?.image_1920 != null
                ? Image.memory(
                    base64Decode(productTemplate!.image_1920.toString()),
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    'assets/images/dish.png',
                    fit: BoxFit.fill,
                  ),
          ),
          SizedBox(
            width: Get.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productTemplate!.product_variant_id?[1].substring(
                      productTemplate.product_variant_id?[1].indexOf("]") + 1),
                  style: AppFont.Title_H6_Bold(),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${Tools.doubleToVND(lst_price)} đ/${productTemplate.uom_id?[1] ?? 'đơn vị'}',
                  style: AppFont.Title_TF_Regular(),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              SaleOrderLineController saleOrderLineController =
                  Get.find<SaleOrderLineController>();
              saleOrderLineController.clear();
              addProduct(
                productTemplate: productTemplate,
                lst_price: lst_price,
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: Get.height * 0.03,
              width: Get.width * 0.15,
              decoration: BoxDecoration(
                  color: AppColors.bgDark,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Thêm',
                style: AppFont.Body_Regular(color: AppColors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  void addProduct({ProductTemplateRecord? productTemplate, double? lst_price}) {
    Get.dialog(
      GetBuilder<SaleOrderLineController>(builder: (controller) {
        return CustomDialog.dialogWidget(
            title: 'Thêm sản phẩm',
            exitButton: false,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  productTemplate!.product_variant_id?[1].substring(
                      productTemplate.product_variant_id?[1].indexOf("]") + 1),
                  style: AppFont.Title_H5_Bold(),
                ),
                Text(
                  '${Tools.doubleToVND(lst_price)} đ/${productTemplate.uom_id?[1] ?? 'đơn vị'}',
                  style: AppFont.Title_TF_Regular(),
                ),
                SizedBox(height: Get.height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                  height: Get.height * 0.06,
                  width: Get.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildMinusPlusButton(
                        isMinus: true,
                        onTap: () {
                          controller.saleOrderLine.value.product_uom_qty =
                              controller.saleOrderLine.value.product_uom_qty !=
                                          null &&
                                      controller.saleOrderLine.value
                                              .product_uom_qty! >
                                          1
                                  ? controller.saleOrderLine.value
                                          .product_uom_qty! -
                                      1
                                  : 0;
                          controller.update();
                        },
                      ),
                      SizedBox(
                        width: Get.width * 0.25,
                        child: TextField(
                          controller: TextEditingController(
                              text: controller
                                  .saleOrderLine.value.product_uom_qty
                                  .toString()),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (double.tryParse(value) != null) {
                              controller.saleOrderLine.value.product_uom_qty =
                                  double.parse(value);
                            }
                          },
                        ),
                      ),
                      buildMinusPlusButton(onTap: () {
                        controller.saleOrderLine.value.product_uom_qty =
                            controller.saleOrderLine.value.product_uom_qty !=
                                    null
                                ? controller
                                        .saleOrderLine.value.product_uom_qty! +
                                    1
                                : 1;
                        controller.update();
                      }),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Container(
                  height: Get.height * 0.1,
                  width: Get.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: TextEditingController(
                        text: controller.saleOrderLine.value.remarks),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onChanged: (value) {
                      controller.saleOrderLine.value.remarks = value;
                    },
                  ),
                ),
              ],
            ),
            actions: [
              CustomDialog.popUpButton(
                onTap: () {
                  Get.find<SaleOrderLineController>().saleOrderLine =
                      SaleOrderLineRecord.publicSaleOrderLine().obs;
                  Get.back();
                },
                child: Text(
                  'Huỷ',
                  style: AppFont.Body_Regular(),
                ),
                color: AppColors.dismissColor,
              ),
              CustomDialog.popUpButton(
                  child: Text(
                    'Xác nhận',
                    style: AppFont.Body_Regular(color: AppColors.white),
                  ),
                  color: AppColors.acceptColor,
                  onTap: () {
                    SaleOrderLineController saleOrderLineController =
                        Get.find<SaleOrderLineController>();

                    saleOrderLineController.saleOrderLine.value.product_id =
                        productTemplate.product_variant_id;
                    saleOrderLineController.saleOrderLine.value.name =
                        "[${productTemplate.default_code}] ${productTemplate.name}";
                    saleOrderLineController.saleOrderLine.value.price_unit =
                        lst_price;
                    saleOrderLineController.saleOrderLine.value.product_uom =
                        productTemplate.uom_id;
                    saleOrderLineController.saleOrderLine.value.order_id = [
                      Get.find<SaleOrderController>().saleOrderRecord.value.id,
                      Get.find<SaleOrderController>().saleOrderRecord.value.name
                    ];
                    // saleOrderLineController.saleOrderLine.value.discount_type =
                    //     'percent';
                    controller.saleorderlines
                        .add(controller.saleOrderLine.value);
                    controller.saleOrderLine =
                        SaleOrderLineRecord.publicSaleOrderLine().obs;
                    controller.update();
                    // Navigator.of(context).pop();
                    Get.back();

                    Fluttertoast.showToast(
                      msg: "Thêm món thành công!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColors.successColor,
                      textColor: AppColors.white,
                      fontSize: 16.0,
                    );
                  }),
            ]);
      }),
      barrierDismissible: false,
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
}

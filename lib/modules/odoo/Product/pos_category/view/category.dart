import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/widgets/customWidget.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Product/pos_category/controller/category_controller.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';

class PosCategoryView extends StatelessWidget {
  const PosCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosCategoryController>(builder: (controller) {
      return Container(
        height: Get.height * 0.2,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomMiniWidget.squareButton(
                  color: AppColors.bgLight,
                  child: Icon(
                    Icons.undo,
                    color: AppColors.iconColor,
                  ),
                  onTap: () {
                    controller.undoCategory();
                  },
                ),
                SizedBox(width: Get.width * 0.03),
                CustomMiniWidget.squareButton(
                  onTap: () {
                    controller.parentCategory.clear();
                    controller.filter(
                        null, [Get.find<PosController>().pos.value.id], true);
                  },
                  child: Text(
                    'Tất cả',
                    style: AppFont.Body_Regular(color: AppColors.white),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.04,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.categoryFilters.length,
                itemBuilder: (context, index) {
                  return CustomMiniWidget.listButton(
                    title: controller.categoryFilters[index].name,
                    onTap: () {
                      controller.parentCategory.clear();
                      controller.parentCategory
                          .add(controller.categoryFilters[index]);
                      controller.filter(
                          [controller.categoryFilters[index].id], null, true);
                      controller.categoryFilters.add(
                          Get.find<PosCategoryController>().parentCategory[0]);
                      controller.update();
                    },
                  );
                },
              ),
            ),
            Container(
              height: Get.height * 0.06,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white),
              child: GetBuilder<ProductTemplateController>(
                  builder: (protempcontroler) {
                return TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.iconColor,
                    ),
                    hintText: 'Tìm kiếm sản phẩm theo tên',
                    hintStyle:
                        AppFont.Body_Regular(color: AppColors.placeholderText),
                  ),
                  onChanged: protempcontroler.updateSearchText,
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:get/get.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';
import 'package:test/modules/odoo/Product/pos_category/repository/category_record.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';

class PosCategoryController extends GetxController {
  RxList<PosCategoryRecord> categories = <PosCategoryRecord>[].obs;
  RxList<PosCategoryRecord> categoryFilters = <PosCategoryRecord>[].obs;
  RxList<PosCategoryRecord> parentCategory = <PosCategoryRecord>[].obs;
  Rx<PosCategoryRecord> category = PosCategoryRecord.publicCate().obs;

  void clear() {
    categories = <PosCategoryRecord>[].obs;
    categoryFilters = <PosCategoryRecord>[].obs;
    parentCategory = <PosCategoryRecord>[].obs;
  }

  List<PosCategoryRecord> getAllChildrenCategories(
      PosCategoryRecord category, List<dynamic>? listIds) {
    List<PosCategoryRecord> children = [];
    for (var cat in categories) {
      if (listIds != null && listIds.isNotEmpty) {
        if (cat.parent_id != null &&
            cat.parent_id!.isNotEmpty &&
            cat.parent_id![0] == category.id &&
            listIds.contains(cat.id)) {
          children.add(cat);
          children.addAll(getAllChildrenCategories(cat, null));
        }
      } else {
        if (cat.parent_id != null &&
            cat.parent_id!.isNotEmpty &&
            cat.parent_id![0] == category.id) {
          children.add(cat);
          children.addAll(getAllChildrenCategories(cat, null));
        }
      }
    }

    return children;
  }

  void undoCategory() {
    if (parentCategory.isNotEmpty &&
        categories.firstWhereOrNull(
                (element) => element.id == parentCategory[0].parent_id?[0]) !=
            null) {
      PosCategoryRecord posCategoryRecord = categories.firstWhere(
          (element) => element.id == parentCategory[0].parent_id?[0]);
      parentCategory.clear();
      parentCategory.add(posCategoryRecord);
      filter([posCategoryRecord.id], null, true);
      categoryFilters.add(posCategoryRecord);
    } else {
      parentCategory.clear();
      filter(
          null, [Get.find<PosController>().pos.value.id], true);
    }
    update();
  }

  Future filter(List<int>? value, List<int>? idPos, bool clear) async {
    List<dynamic>? listIds;
    if (Get.find<PosController>().pos.value.limit_categories == true &&
        Get.find<PosController>().pos.value.available_cat_ids != null) {
      listIds = Get.find<PosController>().pos.value.available_cat_ids;
    }
    if (clear) {
      categoryFilters.clear();
    }
    if (value != null) {
      List<PosCategoryRecord> listFilter = [];
      List<int> listE = [];
      for (var i in value) {
        listE.add(i);
        PosCategoryRecord? idPoscategory = categories.firstWhereOrNull((p0) {
          if (listIds != null) {
            return p0.id == i && listIds.contains(p0.id);
          } else {
            return p0.id == i;
          }
        });
        if (idPoscategory != null &&
            !categoryFilters
                .map((element) => element.id)
                .contains(idPoscategory.id)) {
          if (idPos != null) {
            categoryFilters.add(idPoscategory);
          } else {
            listFilter = getAllChildrenCategories(idPoscategory, listIds);
            categoryFilters.addAll(listFilter);
          }
        }
      }

      ProductTemplateController productTemplateController =
          Get.find<ProductTemplateController>();
      listE.addAll(listFilter.map((listFilter) => listFilter.id).toList());
      productTemplateController.filter(listE);
    } else {
      if (idPos != null) {
        List<int> cateId = [];
        for (int idP in idPos) {
          List<PosRecord> pos =
              Get.find<PosController>().poseFilters.where((p0) {
            return p0.id == idP;
          }).toList();
          if (pos.isNotEmpty) {
            if (pos[0].available_cat_ids != null &&
                pos[0].available_cat_ids!.isNotEmpty &&
                pos[0].limit_categories == true) {
              List<PosCategoryRecord> idsPoscategory = categories.where((p0) {
                return pos[0].available_cat_ids!.contains(p0.id) &&
                    !categoryFilters
                        .map((element) => element.id)
                        .contains(p0.id);
              }).toList();
              categoryFilters.addAll(idsPoscategory);
              cateId.addAll(pos[0]
                  .available_cat_ids!
                  .map((item) => item as int)
                  .toList());
            } else {
              List<ProductTemplateRecord> ids =
                  Get.find<ProductTemplateController>().products.where((p0) {
                if (p0.available_in_pos != null) {
                  return p0.available_in_pos == true;
                }
                return false;
              }).toList();
              for (var item in ids) {
                if (cateId.contains(item.pos_categ_id?[0]) == false) {
                  cateId.add(item.pos_categ_id?[0]);
                }
              }
            }
          }
        }
        filter(cateId, idPos, false);
      }
    }
    update();
  }
}

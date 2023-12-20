import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/utils/tools.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/Product/product_product/controller/product_product_controller.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_record.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_repos.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';

class ProductTemplateController extends GetxController {
  RxList<ProductTemplateRecord> products = <ProductTemplateRecord>[].obs;
  RxList<ProductTemplateRecord> productFilters = <ProductTemplateRecord>[].obs;
  RxList<ProductTemplateRecord> productSearchs = <ProductTemplateRecord>[].obs;
  RxList<dynamic> productValiDate = [].obs;
  TextEditingController productSearchController = TextEditingController();

  void clear() {
    products = <ProductTemplateRecord>[].obs;
    productFilters = <ProductTemplateRecord>[].obs;
    productSearchs = <ProductTemplateRecord>[].obs;
    productValiDate = [].obs;
    productSearchController = TextEditingController();
  }

  // Search product
  void updateSearchText(String searchText) {
    List<ProductTemplateRecord> listFilter = productFilters.where((p0) {
      return Tools.removeDiacritics(p0.product_variant_id?[1].toLowerCase())
              .contains(Tools.removeDiacritics(searchText.toLowerCase())) ||
          p0.default_code != null &&
              p0.default_code!.isNotEmpty &&
              p0.default_code!.toLowerCase().contains(searchText.toLowerCase());
      // p0.name.toLowerCase().contains(searchText.toLowerCase()) ||
      //     p0.default_code!.isNotEmpty &&
      //         p0.default_code!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
    productSearchs.clear();
    // productSearchs.addAll(listFilter.where((p0) =>
    //     p0.default_code !=
    //     Get.find<BranchController>().branchFilters[0].default_code_surcharge));
    productSearchs.addAll(listFilter);
    update();
  }

  // filter product
  Future<void> filter(List<int> es) async {
    productFilters.clear();
    List<ProductTemplateRecord> listFilter = products.where((p0) {
      if (p0.pos_categ_id != null && p0.pos_categ_id!.isNotEmpty) {
        return es.contains(p0.pos_categ_id?[0]);
      }
      return false;
    }).toList();
    productFilters.addAll(listFilter);
    Get.find<ProductProductController>().filter();
    for (ProductTemplateRecord i in listFilter) {
      // log("${i.product_variant_id}");
      if (i.product_variant_ids!.length > 1) {
        List<int> listIds =
            i.product_variant_ids!.map((item) => item as int).toList();
        for (int ids in listIds) {
          if (i.product_variant_id?[0] != ids) {
            ProductProductRecord? search = Get.find<ProductProductController>()
                .productproductFilters
                .firstWhereOrNull((p0) {
              return p0.id == ids;
            });
            if (search != null) {
              ProductTemplateRecord proNewVariant =
                  ProductTemplateRecord.publicProductTemplate();

              proNewVariant.id = i.id;
              proNewVariant.name = i.name;
              proNewVariant.image_1920 = i.image_1920;
              proNewVariant.available_in_pos = i.available_in_pos;
              proNewVariant.pos_categ_id = i.pos_categ_id;
              proNewVariant.active = i.active;
              proNewVariant.default_code = i.default_code;
              proNewVariant.list_price = i.list_price;
              // proNewVariant.lst_price = i.lst_price;
              proNewVariant.sale_ok = i.sale_ok;
              proNewVariant.uom_id = i.uom_id;
              proNewVariant.taxes_id = i.taxes_id;
              proNewVariant.product_variant_ids = i.product_variant_ids;
              OdooEnvironment env = Get.find<MainController>().env;
              ProductProductRepository productProductRepository =
                  ProductProductRepository(env);

              await productProductRepository.nameGet(search.id).then((result) {
                proNewVariant.product_variant_id = [result[0][0], result[0][1]];
              }).catchError((error) {
                log("er name get $error");
              });
              if (proNewVariant.product_variant_id!.isEmpty) {
                proNewVariant.product_variant_id = [search.id, search.name];
              }
              productFilters.add(proNewVariant);
            }
          }
        }
      }
    }
    productSearchs.clear();
    productSearchs.addAll(productFilters);
    update();
  }

  ProductTemplateRecord? filterProduct(dynamic pro) {
    ProductTemplateRecord? product = productFilters.firstWhereOrNull((element) {
      if (element.product_variant_id != null &&
          element.product_variant_id!.isNotEmpty) {
        return pro != null && element.product_variant_id![0] == pro[0];
      }
      return false;
    });
    return product;
  }

  // reset all
  void resetFilter() {
    productFilters.clear();
    productFilters.addAll(products);
    productSearchs.clear();
    productSearchs.addAll(productFilters);
    update();
  }
}

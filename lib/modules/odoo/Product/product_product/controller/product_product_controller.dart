import 'package:get/get.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_record.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_record.dart';

class ProductProductController extends GetxController {
  RxList<ProductProductRecord> productproducts = <ProductProductRecord>[].obs;
  RxList<ProductProductRecord> productproductFilters =
      <ProductProductRecord>[].obs;

  // khi ổn sẽ chuyển từ product_template sang đây
  RxList<dynamic> productValiDate = [].obs;

  RxList<dynamic> productTemplateIds = [].obs;

  void clear() {
    productproducts = <ProductProductRecord>[].obs;
    productproductFilters = <ProductProductRecord>[].obs;
    // khi ổn sẽ chuyển từ product_template sang đây
    productValiDate = [].obs;
    productTemplateIds = [].obs;
  }

  // filter product
  void filter() {
    List<ProductTemplateRecord> proTemplate =
        Get.find<ProductTemplateController>().productFilters;
    List<int> ids = [];
    for (ProductTemplateRecord template in proTemplate) {
      productTemplateIds.add([template.id, template.name]);
      ids.add(template.id);
    }
    List<ProductProductRecord> listFilter = productproducts.where((p0) {
      if (p0.product_tmpl_id != null && p0.product_tmpl_id!.isNotEmpty) {
        return ids.contains(p0.product_tmpl_id![0]);
      }
      return false;
    }).toList();
    productproductFilters.clear();
    productproductFilters.addAll(listFilter);
    update();
  }

  // reset all
  void resetFilter() {
    productproductFilters.clear();
    productproductFilters.addAll(productproducts);
    update();
  }
}
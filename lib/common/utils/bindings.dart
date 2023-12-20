import 'package:get/get.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/controllers/login_controller.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/controllers/start_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/controller/area_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/controller/branch_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Customer/res_partner/controller/partner_controller.dart';
import 'package:test/modules/odoo/Inventory/stock_move/controller/stock_move_controller.dart';
import 'package:test/modules/odoo/Inventory/stock_picking/controller/stock_picking_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Product/pos_category/controller/category_controller.dart';
import 'package:test/modules/odoo/Product/product_product/controller/product_product_controller.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';

class InitialBindings extends Bindings {
  @override
  Future dependencies() async {
    await mainController();
  }

  Future<void> mainController() async {
    Get.put(MainController());
  }

  Future<void> startController() async {
    Get.put(StartController());
  }

  Future<void> loginController() async {
    Get.put(LoginController());
  }
}

class HomeBindings extends Bindings {
  @override
  Future dependencies() async {
    await homeController();
    await allHomeController();
    await saleorder();
    await partner();
    await saleorderline();
  }

  Future saleorder() async {
    Get.put(SaleOrderController());
  }

  Future partner() async {
    Get.put(ResPartnerController());
  }

  Future saleorderline() async {
    Get.put(SaleOrderLineController());
  }

  Future homeController() async {
    Get.put(HomeController());
  }

  Future allHomeController() async {
    Get.put(BranchController());
    Get.put(PosController());
    Get.put(AreaController());
    Get.put(TableController());
    Get.put(PosCategoryController());
    Get.put(ProductProductController());
    Get.put(ProductTemplateController());
    Get.put(StockPickingController());
    Get.put(StockMoveController());
  }
}

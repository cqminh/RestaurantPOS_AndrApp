import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/controller/area_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/repository/area_repos.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/controller/branch_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/repository/branch_repos.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_record.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/repository/pos_repos.dart';
import 'package:test/modules/odoo/Customer/res_partner/controller/partner_controller.dart';
import 'package:test/modules/odoo/Customer/res_partner/repository/partner_repos.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_record.dart';
import 'package:test/modules/odoo/Order/sale_order/repository/order_repos.dart';
import 'package:test/modules/odoo/Order/sale_order/view/confirmOrder.dart';
import 'package:test/modules/odoo/Order/sale_order_line/controller/order_line_controller.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_record.dart';
import 'package:test/modules/odoo/Order/sale_order_line/repository/order_line_repos.dart';
import 'package:test/modules/odoo/Product/pos_category/controller/category_controller.dart';
import 'package:test/modules/odoo/Product/pos_category/repository/category_repos.dart';
import 'package:test/modules/odoo/Product/product_product/controller/product_product_controller.dart';
import 'package:test/modules/odoo/Product/product_product/repository/product_product_repos.dart';
import 'package:test/modules/odoo/Product/product_template/controller/product_template_controller.dart';
import 'package:test/modules/odoo/Product/product_template/repository/product_template_repos.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_repos.dart';
import 'package:test/modules/odoo/User/res_company/repository/company_record.dart';
import 'package:test/modules/odoo/User/res_company/repository/company_repos.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_record.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_repos.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  TextEditingController selectCompanyController = TextEditingController();
  Rx<PageController> pageController = PageController().obs;
  Rx<User> user = User.publicUser().obs;
  Rx<Company> companyUser = Company.initCompany().obs;

  RxInt status = 0.obs;
  RxBool statusSave = false.obs;
  RxList<User> users = <User>[].obs;
  RxList<Company> companiesOfU = <Company>[].obs;

  get id => null;

  get companyId => null;

  Future reLoad() async {
    statusSave.value = true;
    await onInit();
    statusSave.value = false;
  }

  Future<int> changeCompany(Company company) async {
    MainController mainController = Get.find<MainController>();
    int result =
        await CompanyRepository(mainController.env).changeCompany(company.id);
    if (result == 1) {
      companyUser.value = company;
      user.value.companyId = [company.id, company.name];

      UserRepository(mainController.env).fetchRecords();
      UserRepository(mainController.env).write(user.value);
      await reLoad();
    }

    return result;
  }

  Future autoFetchData() async {
    MainController mainController = Get.find<MainController>();
    if (Get.find<BranchController>().branchFilters.isNotEmpty &&
        Get.find<BranchController>().branchFilters[0].period != null &&
        Get.find<BranchController>().branchFilters[0].period! > 0) {
      log("kà kà");
      mainController.startPeriodicTask(
          (Get.find<BranchController>().branchFilters[0].period! * 60 * 60)
              .toInt());
    } else {
      log("ka ka");
      if (mainController.timer != null) {
        mainController.stopPeriodicTask();
      }
    }
  }

  Future clearAllData() async {
    Get.find<BranchController>().clear();
    Get.find<PosController>().clear();
    Get.find<AreaController>().clear();
    Get.find<ResPartnerController>().clear();
    Get.find<PosCategoryController>().clear();
    Get.find<TableController>().clear();
    Get.find<ProductProductController>().clear();
    Get.find<ProductTemplateController>().clear();
  }

  Future getData() async {
    log("init hom controller");
    MainController mainController = Get.find<MainController>();
    OdooEnvironment env = mainController.env;
    // data không đổi
    env.add(BranchRepository(env));
    env.add(PosRepository(env));
    env.add(AreaRepository(env));
    env.add(TableRepository(env));
    env.add(PosCategoryRepository(env));
    env.add(ProductProductRepository(env));
    env.add(ProductTemplateRepository(env));
    env.add(ResPartnerRepository(env));
    env.add(SaleOrderRepository(env));
    env.add(SaleOrderLineRepository(env));

    status.value = 1;
    await MainController.to.env.of<UserRepository>().fetchRecords();
    //
    await MainController.to.env.of<CompanyRepository>().fetchRecords();

    users.value = MainController.to.env.of<UserRepository>().latestRecords;
    if (users.isNotEmpty) {
      user.value = users.firstWhereOrNull(
              (element) => element.id == env.orpc.sessionId!.userId) ??
          User.publicUser();
    }
    companiesOfU.value =
        MainController.to.env.of<CompanyRepository>().latestRecords;
    await clearAllData();
    if (user.value.companyId != null && user.value.companyId!.isNotEmpty) {
      int cId = user.value.companyId![0];
      try {
        companyUser.value = companiesOfU.where((p0) => p0.id == cId).first;
        // fetchrecord của những bảng có domain theo company hoặc user hoặc data không đổi //
        // --------------------------------------//-------------------------------------------- //

        // BRANCH
        List domainCompanyId = [
          ['company_id', '=', companyUser.value.id]
        ];
        MainController.to.env.of<BranchRepository>().domain = domainCompanyId;
        await mainController.env.of<BranchRepository>().fetchRecords();
        Get.find<BranchController>().branchs.value =
            MainController.to.env.of<BranchRepository>().latestRecords.toList();
        // ------------------------------------------------------------------
        // lỗi khi USER chỉ có quyền trên POS nên không lấy được BRANCH tạm thời bỏ lọc theo user
        List<int> branchIds = [];
        List<dynamic> userIds = [];
        Get.find<BranchController>().branchFilters.value =
            Get.find<BranchController>().branchs.where((p0) {
          if (p0.company_id != null && p0.company_id?[0] == companyUser.value.id
              // && p0.user_ids != null && p0.user_ids!.contains(user.value.id)
              ) {
            branchIds.add(p0.id);
            if (p0.user_ids != null) {
              userIds.addAll(p0.user_ids as Iterable);
            }
            return true;
          }
          return false;
        }).toList();
        // --------------------------------------//-------------------------------------------- //

        if (branchIds.isNotEmpty) {
          // POS
          MainController.to.env.of<PosRepository>().domain = [
            ['company_id', '=', companyUser.value.id],
            ['branch_id', 'in', branchIds],
            // ['pos_type', '=', 'restaurant'],
          ];
          await mainController.env.of<PosRepository>().fetchRecords();
          Get.find<PosController>().pose.value =
              mainController.env.of<PosRepository>().latestRecords.toList();
          Get.find<PosController>().poseFilters.value =
              Get.find<PosController>().pose.where((p0) {
            // nếu user nằm trong BRANCH thì lấy ALL POS của BRANCH đó
            if (branchIds.isNotEmpty &&
                Get.find<BranchController>().branchs.firstWhereOrNull((p0) =>
                        p0.user_ids != null &&
                        p0.company_id != null &&
                        p0.company_id?[0] == companyUser.value.id &&
                        p0.user_ids!.contains(user.value.id)) !=
                    null) {
              return p0.company_id != null &&
                  p0.company_id?[0] == companyUser.value.id &&
                  p0.branch_id != null &&
                  branchIds.contains(p0.branch_id?[0]);
            }
            // nếu user không nằm trong BRANCH thì lấy POS của user có quyền trên đó
            return p0.company_id != null &&
                p0.company_id?[0] == companyUser.value.id &&
                p0.user_ids != null &&
                p0.user_ids!.contains(user.value.id);
          }).toList();
          if (Get.find<PosController>().poseFilters.firstWhereOrNull(
                  (element) =>
                      element.id == Get.find<PosController>().pos.value.id) ==
              null) {
            Get.find<PosController>().pos.value =
                Get.find<PosController>().poseFilters[0];
          }
          // --------------------------------------//-------------------------------------------- //

          List<int> posIds = [];
          for (PosRecord pos in Get.find<PosController>().poseFilters) {
            posIds.add(pos.id);
            if (pos.user_ids != null) {
              userIds.addAll(pos.user_ids as Iterable);
            }
            // if (pos.available_pricelist_ids != null) {
            //   priceListIds.addAll(pos.available_pricelist_ids!.whereType<int>().toList());
            // }
          }
          if (posIds.isNotEmpty) {
            OdooEnvironment env = mainController.env;
            users.value = users.where((p0) => userIds.contains(p0.id)).toList();
            // PARTNER
            ResPartnerRepository partnerRepository = ResPartnerRepository(env);
            await partnerRepository.fetchRecords();
            Get.find<ResPartnerController>().partners.value =
                partnerRepository.latestRecords.toList();
            // --------------------------------------//-------------------------------------------- //

            // AREA
            mainController.env.of<AreaRepository>().domain = [
              ['company_id', '=', companyUser.value.id],
              ['pos_ids', 'in', posIds]
            ];
            await mainController.env.of<AreaRepository>().fetchRecords();
            Get.find<AreaController>().areas.value =
                mainController.env.of<AreaRepository>().latestRecords.toList();
            Get.find<AreaController>().areafilters.value =
                mainController.env.of<AreaRepository>().latestRecords.toList();
            // fillter
            Get.find<AreaController>()
                .filter([Get.find<PosController>().pos.value.id]);
            // --------------------------------------//-------------------------------------------- //

            // TABLE
            List domainCompanyPos = [
              ['company_id', '=', companyUser.value.id],
              ['pos_id', 'in', posIds]
            ];
            TableRepository tableRepository = TableRepository(env);
            tableRepository.domain = domainCompanyPos;
            await tableRepository.fetchRecords();
            Get.find<TableController>().tables.value =
                tableRepository.latestRecords.toList();
            Get.find<TableController>().tablefilters.value =
                // fillter
                tableRepository.latestRecords.toList();
            Get.find<TableController>()
                .filter(null, [Get.find<PosController>().pos.value.id]);
            if (Get.find<TableController>().table.value.id > 0) {
              Get.find<TableController>().table.value =
                  Get.find<TableController>().tablefilters.firstWhereOrNull(
                          (element) =>
                              element.id ==
                              Get.find<TableController>().table.value.id) ??
                      TableRecord.publicTable();
            }
            // --------------------------------------//-------------------------------------------- //

            // POS CATEGORY
            await mainController.env.of<PosCategoryRepository>().fetchRecords();
            Get.find<PosCategoryController>().categories.value = mainController
                .env
                .of<PosCategoryRepository>()
                .latestRecords
                .toList();
            // fillter
            Get.find<PosCategoryController>()
                .filter(null, [Get.find<PosController>().pos.value.id], true);
            // --------------------------------------//-------------------------------------------- //

            // PRODUCT
            // product.product
            MainController.to.env.of<ProductProductRepository>().domain = [
              // ['company_id', '=', companyUser.value.id],
              ['active', '=', true]
            ];
            await mainController.env
                .of<ProductProductRepository>()
                .fetchRecords();
            Get.find<ProductProductController>().productproducts.value =
                mainController.env
                    .of<ProductProductRepository>()
                    .latestRecords
                    .toList();
            Get.find<ProductProductController>().productproductFilters.value =
                mainController.env
                    .of<ProductProductRepository>()
                    .latestRecords
                    .toList();

            // product.template
            MainController.to.env.of<ProductTemplateRepository>().domain = [
              // ['company_id', '=', companyUser.value.id],
              ['active', '=', true],
              ['sale_ok', '=', true],
              ['available_in_pos', '=', true],
            ];
            await mainController.env
                .of<ProductTemplateRepository>()
                .fetchRecords();
            Get.find<ProductTemplateController>().products.value =
                mainController.env
                    .of<ProductTemplateRepository>()
                    .latestRecords
                    .toList();
            Get.find<ProductTemplateController>().productFilters.value =
                mainController.env
                    .of<ProductTemplateRepository>()
                    .latestRecords
                    .toList();
            Get.find<ProductTemplateController>()
                .productSearchs
                .addAll(Get.find<ProductTemplateController>().productFilters);
            // --------------------------------------//-------------------------------------------- //

            // ----------------------------------- // --------------------------------------------- //
            // sale order nếu tồn tại sẽ load lại
            if (Get.find<SaleOrderLineController>().saleorderlines.isNotEmpty) {
              await Get.find<SaleOrderController>().getSaleOrder(
                  Get.find<TableController>().table.value, false, false);
            }
          }
        }
      } catch (e) {
        status.value = 3;
        log("company id $cId", name: "HomeController onInit");
        log("$e", name: "HomeController onInit");
      }
    }

    status.value = 2;
    selectCompanyController.text = "ABC";
    update();
  }

  @override
  Future onInit() async {
    await getData();
    autoFetchData();
    super.onInit();
    log("end home");
    // Sử dụng ever để lắng nghe sự thay đổi của currentRoute
    ever(Get.find<MainController>().currentRoute, (currentRoute) async {
      // Xử lý dựa trên giá trị mới của currentRoute
      log("Route đã thay đổi thành: $currentRoute");
      // Đưa logic xử lý ở đây
      bool check = false;
      if (currentRoute != "/product_template" &&
          currentRoute != "/sale_order") {
        // kiểm tra xem có thay đổi chưa lưu không
        if (Get.find<SaleOrderLineController>()
                .saleorderlines
                .firstWhereOrNull((element) => element.id == 0) !=
            null) {
          await ConfirmSaveOrder().confirmDialog();
          check = true;
        } else {
          for (SaleOrderLineRecord line
              in Get.find<SaleOrderLineController>().saleorderlines) {
            SaleOrderLineRecord? temp = Get.find<SaleOrderLineController>()
                .saleorderlinesold
                .firstWhereOrNull((element) => element.id == line.id);
            if (temp != null) {
              if (temp.remarks != line.remarks ||
                  temp.product_uom_qty != line.product_uom_qty ||
                  temp.qty_reserved != line.qty_reserved) {
                await ConfirmSaveOrder().confirmDialog();
                check = true;
              }
            }
          }
        }
        // sau khi lưu xong
        if (Get.find<TableController>().table.value.id > 0 && !check) {
          Get.find<TableController>().table.value = TableRecord.publicTable();
          Get.find<SaleOrderController>().saleOrderRecord.value =
              SaleOrderRecord.publicSaleOrder();
          Get.find<SaleOrderLineController>().saleOrderLine.value =
              SaleOrderLineRecord.publicSaleOrderLine();
          Get.find<SaleOrderLineController>().saleorderlines.clear();
        }
      }
      // log("1111 ${Get.find<TableController>().table.value} == ${Get.find<SaleOrderLineController>().saleorderlines}");
    });

    // Khởi tạo currentRoute ban đầu
    Get.find<MainController>().currentRoute.value = Get.currentRoute;
    MainController mainController = Get.find<MainController>();
    // RUN auto fetchdata
    if (Get.find<BranchController>().branchFilters.isNotEmpty &&
        Get.find<BranchController>().branchFilters[0].period != null &&
        Get.find<BranchController>().branchFilters[0].period! > 0) {
      log("kà kà");
      mainController.startPeriodicTask(
          // (Get.find<BranchController>().branchFilters[0].period! * 60 * 60).toInt()
          5);
    } else {
      log("ka ka");
      if (mainController.timer != null) {
        mainController.stopPeriodicTask();
      }
    }
  }
}

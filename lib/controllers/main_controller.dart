import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/common/config/config.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_client.dart';
import 'package:test/common/third_party/OdooRepository/OdooRpc/src/odoo_session.dart';
import 'package:test/common/third_party/OdooRepository/src/odoo_environment.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/controller/area_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_branch/controller/branch_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Order/sale_order/controller/order_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/controller/table_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_record.dart';
import 'package:test/modules/odoo/Table/restaurant_table/repository/table_repos.dart';
import 'package:test/modules/odoo/User/res_company/repository/company_repos.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_repos.dart';

import '../models/network_connect.dart';
import '../models/odoo_kv_hive_impl.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();
  OdooKvHive cache = OdooKvHive();
  NetworkConnectivity netConn = NetworkConnectivity();
  late OdooEnvironment env;
  Rx<DateTime> dateUpdate =
      DateTime.now().subtract(const Duration(hours: 7)).obs;
  RxInt currentIndexOfNavigatorBottom = 0.obs;
  Timer? timer;
  RxString currentRoute = ''.obs;

  Future<void> logout() async {
    UserRepository(env).logOutUser();
    cache.delete(Config.cacheSessionKey);
    Get.offAllNamed("/login");
    currentIndexOfNavigatorBottom.value = 0;
    // STOP auto fetch data trước đó nếu có
    if (timer != null) {
      stopPeriodicTask();
    }
  }

  void stopPeriodicTask() {
    log("tắt tự động $timer");
    timer?.cancel();
    timer = null;
  }

  Future<void> startPeriodicTask(int second) async {
    dateUpdate = DateTime.parse(Get.find<BranchController>()
                .branchFilters[0]
                .datetime_now ??
            DateTime.now().subtract(const Duration(hours: 7)).obs.toString())
        .obs;
    // STOP auto fetch data trước đó nếu có
    if (timer != null) {
      stopPeriodicTask();
    }
    //
    timer = Timer.periodic(Duration(seconds: second), (timer) async {
      if (!Get.find<HomeController>().statusSave.value) {
        // Gọi các tác vụ muốn thực hiện ở đây
        // ignore: avoid_print
        print(
            'Chạy một lần sau mỗi ${second}s: $dateUpdate ==>  start: ${DateTime.parse(Get.find<BranchController>().branchFilters[0].datetime_now ?? DateTime.now().subtract(const Duration(hours: 7)).obs.toString())}s');
        // TABLE AND ROOM
        TableRepository tableRepository = TableRepository(env);
        List<int> posIds = [];
        for (var pos in Get.find<PosController>().poseFilters) {
          posIds.add(pos.id);
        }
        tableRepository.domain = [
          ['company_id', '=', Get.find<HomeController>().companyUser.value.id],
          ['pos_id', 'in', posIds]
        ];
        await tableRepository.fetchRecords();
        if (tableRepository.latestRecords.toList().isNotEmpty) {
          //cập nhât lại state
          bool check = false;
          for (TableRecord table in tableRepository.latestRecords.toList()) {
            TableRecord? newtable = Get.find<TableController>()
                .tables
                .firstWhereOrNull((element) => element.id == table.id);
            if (newtable == null) {
              Get.find<TableController>().tables.add(table);
              check = true;
            } else {
              if (Get.find<TableController>().table.value.id == newtable.id) {
                Get.find<TableController>().table.value = newtable;
                if (Get.find<TableController>().table.value.status ==
                    "occupied") {
                  // Get.find<HomeController>().statusSave.value = true;
                  check = await Get.find<SaleOrderController>().getSaleOrder(
                      Get.find<TableController>().table.value, false, true);
                  // Get.find<HomeController>().statusSave.value = false;
                }
              }
              if (newtable.status != table.status) {
                newtable.status = table.status;
                if (Get.find<TableController>().table.value.id != newtable.id) {
                  check = true;
                }
              }
            }
          }
          if (check) {
            //  ------------------------------- // FILTER // ------------------ //
            Get.find<TableController>().filter(
                Get.find<AreaController>().area.value.id == 0
                    ? null
                    : [Get.find<AreaController>().area.value.id],
                [Get.find<PosController>().pos.value.id]);
            CustomDialog.snackbar(
              title: 'Thông báo',
              message: 'Có thay đổi đơn hàng',
            );
          }
        }
        dateUpdate = dateUpdate.value.add(Duration(seconds: second)).obs;
      }
    });
  }

  Future init() async {
    await cache.init();
    OdooSession? session =
        cache.get(Config.cacheSessionKey, defaultValue: null);

    env = OdooEnvironment(OdooClient(Config.odooServerURL, session),
        Config.odooDbName, cache, netConn);

    env.add(UserRepository(env));
    env.add(CompanyRepository(env));
  }
}

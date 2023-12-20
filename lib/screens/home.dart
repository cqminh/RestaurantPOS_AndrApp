// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/common/config/app_theme.dart';
import 'package:test/common/widgets/dialogWidget.dart';
import 'package:test/controllers/home_controller.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_area/view/area.dart';
import 'package:test/modules/odoo/BranchPosArea/restaurant_pos/controller/pos_controller.dart';
import 'package:test/modules/odoo/Table/restaurant_table/view/table.dart';
import 'package:test/screens/drawer.dart';
import 'package:test/screens/loading.dart';
// import 'package:get/get.dart';
// import 'package:test/controllers/home_controller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          bool pop = false;
          await Get.dialog(
            CustomDialog.dialogMessage(
              title: 'Xác nhận',
              content: 'Bạn có chắc muốn thoát khỏi ứng dụng?',
              exitButton: false,
              actions: [
                CustomDialog.popUpButton(
                  onTap: () async {
                    Get.back();
                    pop = true;
                  },
                  color: AppColors.acceptColor,
                  child: Text(
                    'Có',
                    style: AppFont.Body_Regular(color: AppColors.white),
                  ),
                ),
                CustomDialog.popUpButton(
                  onTap: () async {
                    Get.back();
                    pop = false;
                  },
                  color: AppColors.dismissColor,
                  child: Text(
                    'Không',
                    style: AppFont.Body_Regular(),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
          return pop;
        },
        child: Get.find<HomeController>().status.value == 3
            ? const Scaffold(
                body: Center(
                    child: Text("Lỗi ứng dụng, liên hệ Nhà phát triển.")))
            : !Get.find<HomeController>().statusSave.value &&
                    Get.find<HomeController>().status.value == 2
                ? SafeArea(
                    child: Scaffold(
                        key: scaffoldKey,
                        appBar: AppBar(
                          backgroundColor: ThemeApp.light().primaryColor,
                          iconTheme: const IconThemeData(color: Colors.white),
                          title: Obx(
                            () => Text(
                              Get.find<PosController>()
                                  .pos
                                  .value
                                  .name
                                  .toString(),
                              style:
                                  AppFont.Title_H5_Bold(color: AppColors.white),
                            ),
                          ),
                          actions: [
                            IconButton(
                              onPressed: () async {
                                if (Get.find<PosController>().pos.value.id >
                                    0) {
                                  await Get.find<HomeController>().reLoad();
                                }
                              },
                              icon: const Icon(
                                Icons.cloud_sync,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        drawer: const DrawerCustom(),
                        body: SafeArea(
                            child: Get.find<PosController>().pos.value.id <= 0
                                ? Center(
                                    child: Text(
                                      'POS không tồn tại!!!',
                                      style: AppFont.Title_H5_Bold(
                                          color: AppColors.acceptColor),
                                    ),
                                  )
                                : const Column(
                                    children: [
                                      AreaDropdown(),
                                      Expanded(
                                        child: TableList(),
                                      ),
                                    ],
                                  )
                            // SingleChildScrollView(
                            //   physics: const BouncingScrollPhysics(),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(20.0),
                            //     child: Get.find<PosController>().pos.value.id <= 0
                            //         ? Center(
                            //             child: Text(
                            //             "POS Không tồn tại!!!",
                            //             style: TextStyle(
                            //                 color: Colors.blue.shade900,
                            //                 fontSize: 20,
                            //                 fontWeight: FontWeight.bold),
                            //           ))
                            //         : const Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 "Danh sách bàn dựa khu vực bàn của POS",
                            //                 style: TextStyle(fontSize: 14),
                            //               ),
                            //               // AreaDropdown(),
                            //               // TableView()
                            //             ],
                            //           ),
                            //   ),
                            // ),
                            )),
                  )
                : const LoadingPage(),
      );
    });
  }
}

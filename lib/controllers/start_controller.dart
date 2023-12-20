import 'dart:developer';

import 'package:get/get.dart';
import 'package:test/controllers/main_controller.dart';
import 'package:test/modules/odoo/User/res_user/repository/user_repos.dart';

class StartController extends GetxController {
  @override
  void onInit() async {
    MainController mainController = Get.find<MainController>();
    await mainController.init();
    int result = await UserRepository(mainController.env).checkSession();
    log("$result", name: "check Session");
    if (result == 1) {
      await Future.delayed(const Duration(milliseconds: 3000));
      Get.offAndToNamed("/home");
    } else {
      await Future.delayed(const Duration(milliseconds: 3000));
      Get.offAndToNamed("/login");
    }
    super.onInit();
  }
}
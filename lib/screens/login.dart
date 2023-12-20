import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';
import 'package:test/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Baground
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Lớp phủ Background
            Container(
              decoration: BoxDecoration(
                  color: AppColors.blurColor(AppColors.bgDark, 0.5)),
            ),

            // Form đăng nhập
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: Get.width * 0.8,
                height: Get.height * 0.5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ĐĂNG NHẬP',
                          style: AppFont.Title_H2_Bold(
                            color: AppColors.darkBlue,
                          )),
                      SizedBox(height: Get.height * 0.05),
                      buildUserNameField(),
                      SizedBox(height: Get.height * 0.01),
                      buildPasswordField(),
                      SizedBox(height: Get.height * 0.05),
                      buildLoginButton(),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildUserNameField() {
    return SizedBox(
      width: Get.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('Tài khoản', style: AppFont.Title_TF_Regular()),
          ),
          TextFormField(
            controller: Get.find<LoginController>().controllerUsername.value,
            onChanged: (value) {
              Get.find<LoginController>().username.value = value;
            },
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: "Nhập tài khoản",
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(
                Icons.person,
                color: AppColors.iconColor,
              ),
              errorText: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField() {
    return SizedBox(
      width: Get.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('Mật khẩu', style: AppFont.Title_TF_Regular()),
          ),
          Obx(
            () => TextFormField(
              controller: Get.find<LoginController>().controllerPassword.value,
              onChanged: (value) {
                Get.find<LoginController>().password.value = value;
              },
              obscureText: Get.find<LoginController>().isInvisibilityPass.value,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: "Nhập mật khẩu",
                prefixIcon: Icon(
                  Icons.lock,
                  color: AppColors.iconColor,
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                      Get.find<LoginController>().isInvisibilityPass.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.iconColor,
                    ),
                    onPressed: () {
                      Get.find<LoginController>().isInvisibilityPass.value =
                          !Get.find<LoginController>().isInvisibilityPass.value;
                    }),
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorText: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return RoundedLoadingButton(
      height: 50,
      width: Get.width * 0.6,
      successColor: AppColors.successColor,
      color: AppColors.darkBlue,
      borderRadius: 20,
      controller: Get.find<LoginController>().buttonLoginController.value,
      onPressed: () async {
        await Get.find<LoginController>().login();
      },
      child: Text("Đăng nhập",
          style: AppFont.Title_H5_Bold(color: AppColors.white)),
    );
  }
}

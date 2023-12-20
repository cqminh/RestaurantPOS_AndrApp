// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'package:test/common/config/app_theme.dart';
import 'package:test/common/utils/bindings.dart';
import 'package:test/modules/odoo/Order/sale_order/view/order.dart';
import 'package:test/modules/odoo/Product/product_template/view/product.dart';
import 'package:test/screens/home.dart';
import 'package:test/screens/login.dart';
import 'package:test/screens/start.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  Get.config(
    enableLog: false,
    defaultTransition: Transition.native,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(Phoenix(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(MainController());
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
      enableLog: false,
      theme: ThemeApp.light(),
      initialRoute: "/",
      initialBinding: InitialBindings(),
      getPages: [
        GetPage(
          name: "/",
          page: () => const StartPage(),
        ),
        GetPage(
            name: "/login",
            page: () => const LoginPage(),
            binding: InitialBindings(),
            transition: Transition.noTransition),
        GetPage(
            name: "/home",
            page: () => const Home(),
            binding: HomeBindings(),
            transition: Transition.noTransition),
        GetPage(
          name: "/sale_order",
          page: () => const SaleOrderView(),
        ),
        GetPage(
          name: "/product_template",
          page: () => const ProductTemplateView(),
        ),
      ],
    );
  }
}

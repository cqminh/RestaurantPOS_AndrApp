import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:test/controllers/start_controller.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StartController());

    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/videos/start.gif'),
          fit: BoxFit.cover,
        )),
      )),
    );
  }
}

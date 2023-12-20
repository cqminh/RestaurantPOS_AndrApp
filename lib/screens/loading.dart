import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png'),
                    LoadingAnimationWidget.hexagonDots(
                      color: AppColors.mainColor,
                      size: 40,
                    ),
                  ],
                ),
              ),
              Text(
                'Bản quyền thuộc về Châu Quang Minh',
                style: AppFont.Title_H6_Bold(color: AppColors.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

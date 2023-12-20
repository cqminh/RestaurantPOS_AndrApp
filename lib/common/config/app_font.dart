// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:test/common/config/app_color.dart';

class AppFont {
  AppFont._();

  static const Montserrat_Black = 'MontserratBlack';
  static const Montserrat_BlackItalic = 'MontserratBlackItalic';
  static const Montserrat_Bold = 'MontserratBold';
  static const Montserrat_BoldItalic = 'MontserratBoldItalic';
  static const Montserrat_Italic = 'MontserratItalic';
  static const Montserrat_Light = 'MontserratLight';
  static const Montserrat_LightItalic = 'MontserratLightItalic';
  static const Montserrat_Medium = 'MontserratMedium';
  static const Montserrat_MediumItalic = 'MontserratMediumItalic';
  static const Montserrat_Regular = 'MontserratRegular';
  static const Montserrat_Thin = 'MontserratThin';
  static const Montserrat_ThinItalic = 'MontserratThinItalic';

  // Text Feature's Style
  static TextStyle Title_H2_Bold({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Bold,
      fontSize: size ?? 40,
    );
  }
  static TextStyle Title_H5_Bold({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Bold,
      fontSize: size ?? 17,
    );
  }
  static TextStyle Title_H6_Bold({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Bold,
      fontSize: size ?? 15,
    );
  }

  static TextStyle Body_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Regular,
      fontSize: size ?? 14,
    );
  }
  static TextStyle Body_Italic({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Italic,
      fontSize: size ?? 14,
    );
  }
  static TextStyle Title_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Montserrat_Regular,
      fontSize: size ?? 16,
    );
  }
  static TextStyle Title_TF_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.titleTextField,
      fontFamily: Montserrat_Regular,
      fontSize: size ?? 13,
    );
  }
}
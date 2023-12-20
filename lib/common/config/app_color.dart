import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // normal color
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);
  // palette
  static Color darkBlue = const Color(0xFF0A2647);
  static Color red = const Color(0xFFE74646);

  // color of text's features
  static Color titleTextField = const Color(0xFF828487);
  static Color placeholderText = const Color(0xFFC4C1A4);

  // color of specific objects
  static Color successColor = Colors.green;
  static Color dangerColor = Colors.yellow;
  static Color errorColor = Colors.red;

  static Color iconColor = const Color(0xFF0A2647);
  static Color borderColor = const Color(0xFF828487);

  static Color mainColor = const Color(0xFF0A2647);
  static Color bgLight = const Color(0xFFDDE6ED);
  static Color bgDark = const Color(0xFF526D82);
  static Color bgTable = const Color(0xFFEEF1FF);

  static Color chosenColor = const Color(0xFF27374D);
  static Color occupiedColor = const Color(0xFFA8DF8E);
  static Color capacityColor = const Color(0xFF27374D);

  static Color acceptColor = const Color(0xFF0A2647);
  static Color dismissColor = const Color(0xFFC4C1A4);

  // blur color
  static Color blurColor(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}

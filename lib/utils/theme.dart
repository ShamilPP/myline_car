import 'package:flutter/material.dart';
import 'package:myline_car/utils/colors.dart';

class MyLineTheme {
  static ThemeData lightThemeData() {
    return ThemeData(
      colorSchemeSeed: colors.primaryColor,
      appBarTheme: AppBarTheme(color: colors.primaryColor,foregroundColor: colors.foreColor)
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData();
  }
}

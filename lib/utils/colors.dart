import 'package:flutter/material.dart';

class colors {
  static Color primaryColor = const Color(0xFF880E4F);
  static Color bgColor = const Color(0xFFE3E3E3);
  static Color foreColor = const Color(0xFFFFFFFF);
  static Color buttonBackground = const Color(0xFF880D3B);

  //Material color
  static Map<int, Color> materialColorCode = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor primarySwatch = MaterialColor(0xFF880E4F, materialColorCode);
}

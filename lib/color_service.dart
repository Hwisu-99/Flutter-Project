import 'package:flutter/material.dart';


// 자동으로 색상을 계산하여 swatch를 만들어주는 함수
class ColorService {

  Color color1 = Color(0xff265A52);
  Color color2 = Color(0xff9AC5F4);
  Color color3 = Color(0xffA7ECEE);
  Color color4 = Color(0xffFFEEBB);


  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
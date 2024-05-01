import 'package:flutter/material.dart';

class MyColors{
  static const  kPrimaryColor=Color(0xff6366b3);
  static const  kGifBackGroundColor=Color(0xffe1f5ff);
  static const  kGifIconColor=Color(0xff0091ff);

  static const int primaryValue = 0xFF6366B3;
  static const MaterialColor kMapPrimaryColor = MaterialColor(
    primaryValue,
    <int, Color>{
      50: Color(0xFFE8E9F2),
      100: Color(0xFFC5C7E0),
      200: Color(0xFFA1A4CE),
      300: Color(0xFF7D80BC),
      400: Color(0xFF5A5DBA),
      500: Color(primaryValue),
      600: Color(0xFF44489D),
      700: Color(0xFF3A3E8C),
      800: Color(0xFF30357B),
      900: Color(0xFF26296A),
    },
  );
}
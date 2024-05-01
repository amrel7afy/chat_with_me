import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:flutter/material.dart';

import 'my_colors.dart';

ThemeData themeData=ThemeData(
  appBarTheme:  const AppBarTheme(
      backgroundColor: MyColors.kGifBackGroundColor,
    titleTextStyle: MyTextStyles.headLine3
  ),
  primarySwatch: MyColors.kMapPrimaryColor,
  iconTheme: const IconThemeData(
      color: MyColors.kMapPrimaryColor
  ),iconButtonTheme: IconButtonThemeData(style: ButtonStyle(
  iconColor: MaterialStateProperty.all<Color>(
    MyColors.kPrimaryColor,
  ),
)),
  scaffoldBackgroundColor: MyColors.kGifBackGroundColor,
);
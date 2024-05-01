import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(BuildContext context,
    String e ){

  return   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      content: Container(
        alignment: Alignment.center,

      decoration: BoxDecoration(
        color: MyColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(e,style: MyTextStyles.headLine4.copyWith(color: Colors.white,fontSize: 15),),
    ),),);
}
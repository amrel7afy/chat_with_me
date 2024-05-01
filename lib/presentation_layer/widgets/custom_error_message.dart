import 'package:flutter/material.dart';

import '../../constants/my_text_styles.dart';

class CustomErrorMessage extends StatelessWidget {
  final String text;
  const CustomErrorMessage({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text,textAlign: TextAlign.center,style: MyTextStyles.headLine2,),);
  }
}
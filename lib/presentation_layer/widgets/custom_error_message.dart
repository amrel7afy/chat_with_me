import 'package:flutter/material.dart';

import '../../constants/my_text_styles.dart';

class CustomErrorMessage extends StatelessWidget {
  final state;
  const CustomErrorMessage({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(state.error,style: MyTextStyles.headLine2,),);
  }
}
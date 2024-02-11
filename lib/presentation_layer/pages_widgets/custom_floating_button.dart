import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/strings.dart';

class CustomFloatingAction extends StatelessWidget {
  const CustomFloatingAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyColors.kPrimaryColor,
      child:  const Icon(
        Icons.message_rounded,
        color: MyColors.kGifBackGroundColor,
      ),
      onPressed: () {
        Navigator.pushNamed(context, contactsPage);
      },
    );
  }
}
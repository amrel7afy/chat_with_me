import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class NoChatProfileImageAvatar extends StatelessWidget {
  const NoChatProfileImageAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 25,backgroundColor:MyColors.kPrimaryColor ,
      child: CircleAvatar(
        radius:23,
        backgroundColor: MyColors.kGifBackGroundColor,
        backgroundImage: AssetImage('assets/images/profile1.png'),
      ),
    );
  }
}

class NoContactProfileImageAvatar extends StatelessWidget {
  const NoContactProfileImageAvatar({Key? key,required this.noProfileRadius}) : super(key: key);
final double noProfileRadius;
  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: noProfileRadius,backgroundColor:MyColors.kPrimaryColor ,
      child: const CircleAvatar(
        radius:15,
        backgroundColor: MyColors.kGifBackGroundColor,
        backgroundImage: AssetImage('assets/images/profile1.png'),
      ),
    );
  }
}

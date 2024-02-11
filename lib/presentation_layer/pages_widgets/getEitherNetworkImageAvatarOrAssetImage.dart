import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import 'no_profile_image_avatar.dart';

Widget getEitherNetworkImageAvatarOrAssetImage({
 required userModel,
  required double radius,
  required double noProfileRadius
}){
  return userModel.profilePic.isEmpty
      ?   NoContactProfileImageAvatar(noProfileRadius: noProfileRadius,)
      : CircleAvatar(
    radius: radius,
    backgroundColor: MyColors.kPrimaryColor,
    backgroundImage: NetworkImage(userModel.profilePic),
  );
}
import 'dart:developer';

import 'package:chat_with_me/data_layer/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import 'no_profile_image_avatar.dart';

Widget getEitherNetworkImageAvatarOrAssetImage({
 required UserModel userModel,
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
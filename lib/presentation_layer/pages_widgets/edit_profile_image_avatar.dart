import 'dart:core';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/edit_profile_page.dart';

class EditProfileImageAvatar extends StatelessWidget {
  const EditProfileImageAvatar({
    super.key,
    required this.widget,
  });

  final EditProfilePage widget;

  bool checkImageFileIfNull(BuildContext context) {
    if (context.read<LoginCubit>().image == null) {
      return true;
    }
    return false;
  }

  CircleAvatar getImageFile(BuildContext context) {
    if (checkImageFileIfNull(context)) {
      return CircleAvatar(
        radius: 45.0,
        backgroundColor: Colors.blueGrey,
        backgroundImage: NetworkImage(widget.image));

      }
        return   CircleAvatar(
        radius: 45,
        backgroundColor: MyColors.kPrimaryColor,
        backgroundImage: FileImage(
            LoginCubit
                .getCubit(context)
                .image!),
      );
    }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 60.0,
        backgroundColor:
        Theme
            .of(context)
            .scaffoldBackgroundColor,
        child:  Builder(
          builder: (context) {
            return getImageFile(context);
          }
        )

    );
  }
}
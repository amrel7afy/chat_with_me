import 'dart:core';
import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic_layer/login_cubit/login_states.dart';
import '../pages/edit_profile_page.dart';
import '../pages_widgets/edit_profile_image_avatar.dart';

class EditProfileImageAvatarConsumer extends StatelessWidget {
  const EditProfileImageAvatarConsumer({
    super.key,
    required this.widget,
  });

  final EditProfilePage widget;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      builder: (BuildContext context, state) {
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            EditProfileImageAvatar(widget: widget),
            IconButton(
              onPressed: () {
                context.read<LoginCubit>().pickImage();
              },
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: MyColors.kPrimaryColor,
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      },
      listener: (BuildContext context, state) {
        if (state is PickImageErrorState) {
          showSnackBar(context, state.error);
        }
        if (state is StoringFireStoreErrorState) {
          showSnackBar(context, state.error);
        }
        if (state is CacheSetSignedInToTrueState) {
          Navigator.pushReplacementNamed(context, allChatsPage,
              arguments: state.userModel);
          log('Navigated');
        }
      },
    );
  }
}

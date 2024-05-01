import 'package:flutter/material.dart';

import '../../business_logic_layer/chat_cubit/chat_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/strings.dart';
import '../../data_layer/cache_helper.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ChatCubit.getCubit(context).auth.signOut().then((value) {
            Navigator.pushNamedAndRemoveUntil(context, logInPage, (route) => false);
            CacheHelper.removeData(key: userModelKey);
            CacheHelper.removeData(key: isSignedInKey);

          });

        },
        icon: const Icon(
          Icons.exit_to_app_outlined,
          color: MyColors.kPrimaryColor,
        ));
  }
}
import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_text_styles.dart';
import '../../data_layer/models/user_model.dart';
import 'getEitherNetworkImageAvatarOrAssetImage.dart';

class ContactItemBuilder extends StatelessWidget {
  final UserModel userModel;
  final String defaultProfileNetworkImage =
      'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.nicepng.com%2Fpng%2Fdetail%2F933-9332131_profile-picture-default-png.png&tbnid=bLv2FccUvqriEM&vet=10CAYQxiAoB2oXChMI-OCPhr3cgwMVAAAAAB0AAAAAEAc..i&imgrefurl=https%3A%2F%2Fwww.nicepng.com%2Fourpic%2Fu2y3a9e6t4o0a9w7_profile-picture-default-png%2F&docid=-E5pvHnffveX2M&w=820&h=719&itg=1&q=profile%20image%20png&ved=0CAYQxiAoB2oXChMI-OCPhr3cgwMVAAAAAB0AAAAAEAc';

  const ContactItemBuilder({super.key, required this.userModel});

  bool _isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel.name,
              style:
                  MyTextStyles.headLine4.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              userModel.bio,
              overflow: TextOverflow.ellipsis,
              style: MyTextStyles.smallBody,
            )
          ],
        ),
        leading: getEitherNetworkImageAvatarOrAssetImage(radius: 18,noProfileRadius: 18,userModel: userModel),


        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            size: 23,
            Icons.arrow_forward_ios_sharp,
            color: MyColors.kPrimaryColor,
          ),
        ));
  }

}

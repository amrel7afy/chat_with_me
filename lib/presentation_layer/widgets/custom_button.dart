import 'package:chat_app/constants/my_colors.dart';
import 'package:chat_app/constants/my_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          MyColors.kPrimaryColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(
        text,
        style: MyTextStyles.headLine4.copyWith(color: Colors.white),
      ),
    );
  }
}

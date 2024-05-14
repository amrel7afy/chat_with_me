import 'package:flutter/material.dart';




class CustomButton extends StatelessWidget {
  final String text;
   VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final Color backGroundColor;
  final TextStyle textStyle;

   CustomButton({super.key,required this.textStyle, required this.text, required this.backGroundColor,required this.onPressed, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          Colors.black,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          backGroundColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(20),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: FittedBox(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}


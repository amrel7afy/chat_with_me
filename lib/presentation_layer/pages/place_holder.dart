import 'package:chat_with_me/constants/methods.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/presentation_layer/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../constants/my_text_styles.dart';

enum ButtonState { init, loading, done }

class PlaceHolder extends StatefulWidget {
  const PlaceHolder({super.key});

  @override
  State<PlaceHolder> createState() => _PlaceHolderState();
}

class _PlaceHolderState extends State<PlaceHolder> {
  ButtonState state = ButtonState.init;
  bool isAnimating = true;

  @override
  Widget build(BuildContext context) {
    final isStretched = isAnimating || state == ButtonState.init;
    final isDone = state == ButtonState.done;
    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Container(
            alignment: Alignment.center,
            child: AnimatedContainer(
              margin: const EdgeInsets.all(20),
              height: 60,
              width: state == ButtonState.init ? getWidth(context) : 70,
              onEnd: () => setState(() => isAnimating = !isAnimating),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: isStretched
                  ? CustomButton(
                      text: 'Edit',
                      onPressed: () async {
                        setState(() => state = ButtonState.loading);
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() => state = ButtonState.done);
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() => state = ButtonState.init);
                      },textStyle: MyTextStyles.headLine2.copyWith(color: Colors.white), backGroundColor: MyColors.kPrimaryColor
                    )
                  : SmallButton(isDone),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }


}

class SmallButton extends StatelessWidget {
  final bool isDone;

  const SmallButton(
    this.isDone, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone ? Colors.green : MyColors.kPrimaryColor;
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: isDone
            ? const Icon(
                Icons.done,
                color: Colors.white,
                size: 30,
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}

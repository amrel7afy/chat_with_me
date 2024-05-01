import 'dart:async';

import 'package:chat_with_me/business_logic_layer/edit_profile_cubit/edit_profile_state.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/presentation_layer/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/edit_profile_cubit/edit_profile_cubit.dart';
import '../../constants/my_text_styles.dart';

enum ButtonState { init, loading, done }

class AnimatedProgressButton<T,E> extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const AnimatedProgressButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<AnimatedProgressButton> createState() => _AnimatedProgressButtonState();
}

class _AnimatedProgressButtonState extends State<AnimatedProgressButton> {
  ButtonState state = ButtonState.init;
  bool isAnimating = true;
@override
  void setState(VoidCallback fn) {

    if(mounted){
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        playAnimation(state);
      },
      builder: (context, state) {
        final isStretched = isAnimating || this.state == ButtonState.init;
        final isDone = this.state == ButtonState.done;

        return Container(
          alignment: Alignment.center,
          child: AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: this.state == ButtonState.init ? MediaQuery.of(context).size.width : 70,
            onEnd: () => setState(() => isAnimating = !isAnimating),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: isStretched
                ? CustomButton(
                text: widget.text,
                onPressed: widget.onPressed,
                textStyle: MyTextStyles.headLine2.copyWith(color: Colors.white),
                backGroundColor: MyColors.kPrimaryColor)
                : SmallButton(isDone),
          ),
        );
      },
    );
  }

  void playAnimation(EditProfileState state) {
    if (state is EditProfileLoading) {
      setState(() => this.state = ButtonState.loading);
    } else if (state is EditProfileSuccess) {
      setState(() async{
        this.state = ButtonState.done;
       await Future.delayed(const Duration(milliseconds: 100));
        Future.microtask(() => Navigator.pop(context));
      });


    } else {
      setState(() => this.state = ButtonState.init);
    }

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

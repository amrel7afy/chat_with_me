import 'dart:async';

import 'package:chat_with_me/business_logic_layer/edit_profile_cubit/edit_profile_state.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/presentation_layer/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/edit_profile_cubit/edit_profile_cubit.dart';
import '../../constants/my_text_styles.dart';

enum ButtonState { init, loading, done, error }

class EditAnimatedProgressButton extends StatefulWidget {

  final VoidCallback onPressed;

  const EditAnimatedProgressButton({
    super.key,

    required this.onPressed,
  });

  @override
  State<EditAnimatedProgressButton> createState() => _EditAnimatedProgressButtonState();
}

class _EditAnimatedProgressButtonState extends State<EditAnimatedProgressButton> {
  ButtonState state = ButtonState.init;
  bool isAnimating = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
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
        final isError = this.state == ButtonState.error;

        return Container(
          alignment: Alignment.center,
          child: AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: this.state == ButtonState.init
                ? MediaQuery.of(context).size.width
                : 70,
            onEnd: () => setState(() => isAnimating = !isAnimating),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: isStretched
                ? CustomButton(
                    text: 'Edit',
                    onPressed: widget.onPressed,
                    textStyle:
                        MyTextStyles.headLine2.copyWith(color: Colors.white),
                    backGroundColor: MyColors.kPrimaryColor)
                : SmallButton(
                    isDone,
                    isError: isError,
                  ),
          ),
        );
      },
    );
  }

  void playAnimation(EditProfileState state) async {
    if (state is EditProfileLoading) {
      setState(() => this.state = ButtonState.loading);
    } else if (state is EditProfileSuccess) {
      setState(() {
        this.state = ButtonState.done;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      Future.microtask(() => Navigator.pop(context));
    } else if (state is EditProfileError) {
      setState(() => this.state = ButtonState.error);
      await Future.delayed(const Duration(milliseconds: 900));
      setState(() => this.state = ButtonState.init);
    } else {
      setState(() => this.state = ButtonState.init);
    }

  }
}

class SmallButton extends StatelessWidget {
  final bool isDone;
  final bool isError;

  const SmallButton(
    this.isDone, {
    super.key,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final containerColor = getColor();
    final icon= getIcon();

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: containerColor),
      child: Center(child: icon),
    );
  }

  Color getColor() {
    if (isError) {
      return Colors.red;
    } else if (isDone) {
      return Colors.green;
    } else {
      return MyColors.kPrimaryColor;
    }
  }

  Widget getIcon() {
    if (isError) {
      return const Icon(Icons.close,color:Colors.white,);
    } else if (isDone) {
      return const Icon(Icons.check,color:Colors.white,);
    } else {
      return const CircularProgressIndicator(color: Colors.white,);
    }
  }
}

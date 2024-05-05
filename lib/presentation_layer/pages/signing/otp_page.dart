import 'dart:async';
import 'dart:developer';

import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/presentation_layer/widgets/pin_put.dart';
import 'package:chat_with_me/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic_layer/login_cubit/login_cubit.dart';
import '../../../business_logic_layer/login_cubit/login_states.dart';
import '../../../constants/methods.dart';
import '../../../constants/my_text_styles.dart';
import '../../pages_widgets/otp_animated_progress_button.dart';

class OTpPage extends StatefulWidget {
  final String verificationId;

  const OTpPage({super.key, required this.verificationId});

  @override
  State<OTpPage> createState() => _OTpPageState();
}

class _OTpPageState extends State<OTpPage> {
  String? otpCode;

  //final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void onPressed() async {
    if (otpCode != null) {
      verifyOtp(context, otpCode);
    } else {
      showSnackBar(context, 'enter 6-digit code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        builder: (BuildContext context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: getHeight(context),
                width: double.infinity,
                child: Column(
                  children: [
                    const Spacer(
                      flex: 4,
                    ),
                    const Text(
                      'Verification',
                      style: MyTextStyles.headLine1,
                    ),
                    Text(
                      'Enter the OTP send to your phone number',
                      style: MyTextStyles.headLine4.copyWith(fontSize: 15),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    PinPutBuilder(
                      otpCode: otpCode,
                      onCompleted: (value) {
                        otpCode = value;
                        if (kDebugMode) {
                          print(otpCode.toString());
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: getWidth(context) * 0.8,
                        height: 50,
                        child: OTPAnimatedProgressButton(
                          onPressed: onPressed,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Spacer(
                      flex: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, LoginStates state) {
          if (state is LoginFireBaseAuthErrorState) {
            showSnackBar(context, state.error);
            log(state.error);
          }

        },
      ),
    );
  }

  verifyOtp(context, otpCode) {
    LoginCubit.getCubit(context).verifyOTP(
        context: context,
        verificationId: widget.verificationId,
        userOTP: otpCode,
        onSuccess: () {
          LoginCubit.getCubit(context).checkExistingUser().then((value) {
            if (value) {
              LoginCubit.getCubit(context)
                  .getTheUserFromFireStoreWithVerifiedUserID();
            } else {
              Navigator.pushReplacementNamed(context, informationPage);
            }
          });
        });
  }
}

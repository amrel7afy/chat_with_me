import 'dart:async';
import 'dart:developer';

import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/presentation_layer/widgets/pin_put.dart';
import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../business_logic_layer/login_cubit/login_cubit.dart';
import '../../../business_logic_layer/login_cubit/login_states.dart';
import '../../../constants/methods.dart';
import '../../../constants/my_colors.dart';
import '../../../constants/my_text_styles.dart';

class OTpPage extends StatefulWidget {
  final String verificationId;

  const OTpPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTpPage> createState() => _OTpPageState();
}

class _OTpPageState extends State<OTpPage> {
  String ? otpCode;

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();


  void onPressed() async {
    if (otpCode != null) {
      _btnController.start(); // Start the button animation
      // Simulate a loading process for 3 seconds before success state
      Timer(const Duration(seconds: 2), () {
        _btnController.success(); // Transition the button to success state
        verifyOtp(context, otpCode); // Call the login function after the button animation completes
      });
    } else {
      // If validation fails or phone number is empty, reset button state
      _btnController.reset();
      setState(() {
        showSnackBar(context, 'enter 6-digit code');
      });
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
                    onCompleted: (value){
                      otpCode = value;
                      print(otpCode.toString());
                    },
                  ),
                 /* Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CustomButton(
                        text: 'VERIFY',
                        onPressed: () {
                          // if(_formKey.currentState!.validate){
                          if (otpCode != null) {
                            onPressed();
                          } else {
                            setState(() {
                              showSnackBar(context, 'enter 6-digit code');
                            });
                          }
                          // }
                        },
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 20,),
                  RoundedLoadingButton(
                    controller: _btnController,
                    color: MyColors.kPrimaryColor,
                    onPressed: onPressed,
                    width: getWidth(context)*.9,
                    height: 55,
                    child:  Text('VERIFY', style: MyTextStyles.headLine4.copyWith(color: Colors.white)),
                  ),
                  const Spacer(
                    flex: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      }, listener: (BuildContext context, LoginStates state) {
        if (state is LoginFireBaseAuthErrorState){
          showSnackBar(context, state.error);
          log(state.error);
        }
        if(state is CacheSetSignedInToTrueState){
          Navigator.pushReplacementNamed(context, allChatsPage);
        }
      },),
    );
  }

  verifyOtp(context, otpCode) {
    LoginCubit.getCubit(context).verifyOTP(context: context,
        verificationId: widget.verificationId,
        userOTP: otpCode,
        onSuccess: (){
          LoginCubit.getCubit(context).checkExistingUser().then((value) {
            if (value) {
              LoginCubit.getCubit(context).getTheUserFromFireStoreWithVerifiedUserID();
            } else {
              Navigator.pushReplacementNamed(context, informationPage);
            }
          });
        });

  }
}

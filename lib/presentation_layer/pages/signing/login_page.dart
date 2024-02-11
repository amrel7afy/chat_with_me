import 'dart:async';
import 'dart:developer';

import 'package:chat_app/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_app/business_logic_layer/login_cubit/login_states.dart';
import 'package:chat_app/constants/my_colors.dart';
import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../constants/methods.dart';
import '../../../constants/my_text_styles.dart';
import '../../../constants/strings.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController phoneNumberController = TextEditingController();
   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: '20',
    countryCode: 'EG',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'egypt',
    example: 'egypt',
    displayName: 'egypt',
    displayNameNoCountryCode: 'EG',
    e164Key: '',
  );

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void onPressed() async {
    if (formKey.currentState!.validate() &&
        phoneNumberController.text.isNotEmpty) {
      _btnController.start(); // Start the button animation
      // Simulate a loading process for 3 seconds before success state
      Timer(const Duration(seconds: 2), () {
        _btnController.success(); // Transition the button to success state
        login(); // Call the login function after the button animation completes
      });
    } else {
      // If validation fails or phone number is empty, reset button state
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: formKey,
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
                        'Registration',
                        style: MyTextStyles.headLine1,
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      const Text(
                        'Add your phone number. We\'ll send you a',
                        style: MyTextStyles.headLine4,
                      ),
                      const Text(
                        'verification code',
                        style: MyTextStyles.headLine4,
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'enter a phone number';
                            }
                            return null;
                          },
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              enabledBorder: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              errorBorder: const OutlineInputBorder(),
                              hintText: 'Enter your phone number',
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                      context: context,
                                      onSelect: (value) {
                                        setState(() {
                                          selectedCountry = value;
                                        });
                                      },
                                      countryListTheme: CountryListThemeData(
                                          backgroundColor:
                                              MyColors.kGifBackGroundColor,
                                          bottomSheetHeight:
                                              getHeight(context) * .75));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                                    style: MyTextStyles.headLine4,
                                  ),
                                ),
                              )),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      RoundedLoadingButton(
                        controller: _btnController,
                        color: MyColors.kPrimaryColor,
                        onPressed: onPressed,
                        width: getWidth(context) * .9,
                        height: 55,
                        child: Text('LOGIN',
                            style: MyTextStyles.headLine4
                                .copyWith(color: Colors.white)),
                      ),
                      const Spacer(
                        flex: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, LoginStates state) {
          if (state is LoginFireBaseAuthErrorState) {
            if (state.error == 'Enter a valid phone number.') {
              showSnackBar(context, 'Enter a valid phone number.');
              log(state.error);
              _btnController.reset();
            } else {
              showSnackBar(context, 'Some thing is wrong');
              log(state.error);
              _btnController.reset();
            }
          }
          if (state is OTPSentState) {
            Navigator.pushNamed(context, otpPage,
                    arguments: state.verificationId)
                .then((value) => _btnController.reset());
          }
        },
      ),
    );
  }

  void login() {
    LoginCubit.getCubit(context).login(
      context,
      '+${selectedCountry.phoneCode}${phoneNumberController.text.trim()}',
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    _btnController.reset();
    super.dispose();
  }
}

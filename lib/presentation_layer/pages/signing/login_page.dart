import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/business_logic_layer/login_cubit/login_states.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/presentation_layer/widgets/snack_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/methods.dart';
import '../../../constants/my_text_styles.dart';
import '../../../constants/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

/*
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
*/

  bool validated = false;

  @override
  Widget build(BuildContext context) {
    void onPressed() async {
      log(validated.toString());
      if (formKey.currentState!.validate()) {
        setState(() {
          validated = true;
        });
        login();
      } else {
        setState(() {
          validated = false;
        });
      }
    }

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
                            if (value == null || value.isEmpty) {
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
                              prefixIcon: buildCountrySelector(context)),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                  //TODO:
                  /*    SizedBox(
                          width: getWidth(context) * 0.8,
                          child: AnimatedProgressButton(
                            text: 'Login',
                            onPressed: onPressed,

                          )),*/
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
              // _btnController.reset();
            } else {
              showSnackBar(context, 'Some thing is wrong');
              log(state.error);
              //   _btnController.reset();
            }
          }
          if (state is OTPSentState) {
            Navigator.pushNamedAndRemoveUntil(
                    context, otpPage, (route) => false,
                    arguments: state.verificationId)
                //  .then((value) => _btnController.reset())
                ;
          }
        },
      ),
    );
  }

  GestureDetector buildCountrySelector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
            context: context,
            onSelect: (value) {
              setState(() {
                selectedCountry = value;
              });
            },
            countryListTheme: CountryListThemeData(
                backgroundColor: MyColors.kGifBackGroundColor,
                bottomSheetHeight: getHeight(context) * .75));
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
          style: MyTextStyles.headLine4,
        ),
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
    // _btnController.reset();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/constants/widgets/search_field.dart';
import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/data_layer/models/information_field_model.dart';
import 'package:chat_with_me/data_layer/models/user_model.dart';
import 'package:chat_with_me/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic_layer/login_cubit/login_states.dart';
import '../../constants/methods.dart';
import '../../constants/my_text_styles.dart';
import '../widgets/custom_button.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  List<TextEditingController> controllers = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /*final RoundedLoadingButtonController  _btnController =
      RoundedLoadingButtonController();
*/
  void onPressed() async {
    if (formKey.currentState!.validate() &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        bioController.text.isNotEmpty) {
     // _btnController.start(); // Start the button animation
      // Simulate a loading process for 3 seconds before success state
      Timer(const Duration(seconds:10), () {
       // _btnController.success(); // Transition the button to success state
        confirmInformation(); // Call the login function after the button animation completes
      });
    } else {
      // If validation fails or phone number is empty, reset button state
    //  _btnController.reset();
    }
  }

  void confirmInformation() {
    if (LoginCubit.getCubit(context).image != null) {
      formKey.currentState!.save();
      //UserModel userModel = getIt<UserModel>(instanceName: 'init');
      userModel = UserModel(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        bio: bioController.text.trim(),
        userId: '',
        phoneNumber: '',
        profilePic: '',
      );
      LoginCubit.getCubit(context)
          .createUserToFireStore(userModel: userModel, context: context);
    }

    if (LoginCubit.getCubit(context).image == null) {
      showSnackBar(context, 'selecting your image is required');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = [
      nameController,
      emailController,
      bioController
    ];
    return BlocConsumer<LoginCubit, LoginStates>(
      builder: (BuildContext context, state) {
        return Scaffold(
          body: Form(
            key: formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                    height: getHeight(context),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              LoginCubit.getCubit(context).pickImage();
                            },
                            child: LoginCubit.getCubit(context).image == null
                                ? const CircleAvatar(
                                    radius: 45,
                                    backgroundColor: MyColors.kPrimaryColor,
                                    child: Icon(
                                      color: Colors.white,
                                      Icons.account_circle_rounded,
                                      size: 50,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 45,
                                    backgroundColor: MyColors.kPrimaryColor,
                                    backgroundImage: FileImage(
                                        LoginCubit.getCubit(context).image!),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Container(

                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: MyColors.kPrimaryColor
                                              .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: defaultFormField(
                                          hint: fieldModels[index].hint,
                                          prefixIcon: fieldModels[index].icon,
                                          textInputType: TextInputType.text,
                                          textEditingController:
                                              controllers[index],
                                          validate: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Field should not be empty';
                                            }
                                            return null;
                                          }),
                                    ),
                                itemCount: controllers.length),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: getWidth(context)*0.8,
                              height: 50,
                              child: CustomButton(text: 'Continue', onPressed: onPressed,textStyle: MyTextStyles.headLine2.copyWith(color: Colors.white), backGroundColor: MyColors.kPrimaryColor)),
                      /*    RoundedLoadingButton(
                            onPressed: onPressed,
                            height: 55,

                            color: MyColors.kPrimaryColor,
                            controller: _btnController,
                            child: Text('Continue',
                                style: MyTextStyles.headLine4
                                    .copyWith(color: Colors.white)),
                          )*/
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {
        if (state is PickImageErrorState) {
          showSnackBar(context, state.error);
        }
        if (state is StoringFireStoreErrorState) {
          showSnackBar(context, state.error);
        }
        if (state is CacheSetSignedInToTrueState) {
          Navigator.pushReplacementNamed(context,allChatsPage,
              arguments: state.userModel);
          log('Navigated');
        }
      },
    );
  }
}

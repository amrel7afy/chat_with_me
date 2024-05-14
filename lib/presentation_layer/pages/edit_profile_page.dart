import 'dart:core';
import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:chat_with_me/business_logic_layer/edit_profile_cubit/edit_profile_state.dart';
import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/constants/widgets/search_field.dart';
import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/data_layer/models/information_field_model.dart';
import 'package:chat_with_me/presentation_layer/pages_widgets/edit_animated_progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/methods.dart';
import '../pages_widgets/EditProfileImageAvatarConsumer.dart';

class EditProfilePage extends StatefulWidget {
  final image = userModel.profilePic;

  EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  List<TextEditingController> controllers = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onPressed() {
    context.read<EditProfileCubit>().updateUserProfile(context,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim());
  }

  @override
  void initState() {
    nameController.text = userModel.name;
    context.read<EditProfileCubit>().name = nameController.text;
    bioController.text = userModel.bio;
    context.read<EditProfileCubit>().bio = bioController.text;
    emailController.text = userModel.email;
    context.read<EditProfileCubit>().email = emailController.text;

    super.initState();
  }

   validate() {
    log(context.read<LoginCubit>().image?.path ?? 'heloo');
    if (context.read<EditProfileCubit>().name != nameController.text ||
        context.read<EditProfileCubit>().bio != bioController.text ||
        context.read<EditProfileCubit>().email != emailController.text ||
        context.read<LoginCubit>().image != null) {

      onPressed();
      context.read<LoginCubit>().image=null;
    }else{
      (){};
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = [
      nameController,
      emailController,
      bioController
    ];


    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
                height: getHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    EditProfileImageAvatarConsumer(widget: widget),
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
                                    color:
                                        MyColors.kPrimaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: defaultFormField(
                                    hint: fieldModels[index].hint,
                                    prefixIcon: fieldModels[index].icon,
                                    textInputType: TextInputType.text,
                                    textEditingController: controllers[index],
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
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
                    BlocConsumer<EditProfileCubit, EditProfileState>(
                      listener: (context, state) async {},
                      builder: (context, state) {
                        return EditAnimatedProgressButton(
                          onPressed:validate
                        );
                      },
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          //عشان يرجع صورة البروفايل في حالة انه مخترش الصورة الجديدة
          context.read<LoginCubit>().image = null;
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Edit your profile'),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
/*final RoundedLoadingButtonController  _btnController =
      RoundedLoadingButtonController();
*/
/*  void onPressed() async {
    if (formKey.currentState!.validate() &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        bioController.text.isNotEmpty) {
      // _btnController.start(); // Start the button animation
      // Simulate a loading process for 3 seconds before success state
      Timer(const Duration(seconds: 10), () {
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
  }*/

import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../locator.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());
  var userModelDoc = locator<FirebaseFirestore>()
      .collection(kUserCollection)
      .doc(userModel.userId);


  updateUserProfile(BuildContext context,
      {required String name,
      required String email,
      required String bio}) async {
    emit(EditProfileLoading());
    userModel.name = name;
    userModel.email = email;
    userModel.bio = bio;
    if (context.read<LoginCubit>().image != null) {

      await saveImageToStore(context);
    }
    await userModelDoc.update(userModel.toJson()).then((value) async {
      await context.read<LoginCubit>().saveUserToSP();
      emit(EditProfileSuccess());
    }).catchError((e) {
      log(e.toString());
      emit(EditProfileError(e.toString()));
    });
  }

  Future<void> saveImageToStore(BuildContext context) async {
     await context.read<LoginCubit>()
        .storeFileToStorage(
            "profilePic/${locator<FirebaseAuth>().currentUser!.uid}",
            context.read<LoginCubit>().image!)
        .then((value) {
      userModel.profilePic = value;
    }).catchError((e){
       log(e.toString());
      emit(EditProfileError(e.toString()));
     });
  }
}

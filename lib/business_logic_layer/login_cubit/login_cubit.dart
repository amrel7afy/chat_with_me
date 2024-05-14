import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_with_me/constants/methods.dart';

import 'package:chat_with_me/constants/strings.dart';
import 'package:chat_with_me/data_layer/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data_layer/models/user_model.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit getCubit(BuildContext context) => BlocProvider.of(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // UserModel userModel=getIt<UserModel>(instanceName: 'init');
  File? image;

  bool isSignIn = false;
  bool isOnBoarding = false;

  void checkOnBoarding() async {
    isOnBoarding = await CacheHelper.getData(key: isOnBoardingKey) ?? false;
    if (isOnBoarding) {
      emit(CacheOnBoardingSkipState());
    }
  }

  //check sign in
  void checkSignIn() async {
    isSignIn = await CacheHelper.getData(key: isSignedInKey) ?? false;
    if (isSignIn) {
      emit(CacheIsSignedInSuccessState());
    }
  }

  //setCacheSignedIn
  Future setIsSignedInKeyToTrue() async {
    await CacheHelper.saveData(key: isSignedInKey, value: true);
    emit(CacheSetSignedInToTrueState(userModel));
  }

  //login
  login(BuildContext context, String phoneNumber) async {
    emit(LoginLoadingState());
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, int? resendToken) async {
          emit(OTPSentState(verificationId));
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(LoginFireBaseAuthErrorState(e.toString()));
    } catch (e) {
      log(e.toString());
      emit(LoginFailureState(e.toString()));
    }
  }

  verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
  }

  verificationFailed(FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      emit(LoginFireBaseAuthErrorState('Enter a valid phone number.'));
    }
    else{
      emit(LoginFireBaseAuthErrorState(e.message.toString()));
    }

    // Handle other errors
  }

  verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    emit(LoginLoadingState());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        userModel = UserModel(
            email: user.email ?? '',
            userId: user.phoneNumber.toString(),
            bio: '',
            phoneNumber: '',
            profilePic: '',
            name: '');
        onSuccess();
        emit(OTPVerifiedState());

      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFireBaseAuthErrorState(e.toString()));
    }
  }

  Future<bool> checkExistingUser() async {

    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userModel.userId).get();
      if (documentSnapshot.exists) {
        emit(LoginUserExistsState());
        return true;
      } else {
        emit(LoginUserNotExistsState());
        return false;
      }
    } catch (e) {
      log(e.toString());
      emit(LoginFailureState(e.toString()));
      return false;
    }
    //
  }

  getTheUserFromFireStoreWithVerifiedUserID() async {
    if (userModel.userId.isNotEmpty) {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userModel.userId).get();
      userModel = UserModel(
          userId: documentSnapshot['uid'],
          email: documentSnapshot['email'],
          name: documentSnapshot['name'],
          bio: documentSnapshot['bio'],
          phoneNumber: documentSnapshot['phoneNumber'],
          profilePic: documentSnapshot['profilePic']);
      log('getUserFromFireStore');
      await saveUserToSP().then((value) {
        setIsSignedInKeyToTrue();
      });
    }
  }

  Future getTheUserEitherFromFireStoreORCache() async {
    try {
      await getUserFromCache();
    } catch (e) {
      if (userModel.userId.isNotEmpty) {
        DocumentSnapshot documentSnapshot =
            await firestore.collection('users').doc(userModel.userId).get();
        userModel = UserModel(
            userId: documentSnapshot['uid'],
            email: documentSnapshot['email'],
            name: documentSnapshot['name'],
            bio: documentSnapshot['bio'],
            phoneNumber: documentSnapshot['phoneNumber'],
            profilePic: documentSnapshot['profilePic']);
        log('getUserFromFireStore');
        await saveUserToSP().then((value) {
          setIsSignedInKeyToTrue();
        });
      }
    }
  }

  Future<File?> pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        emit(PickImageSuccessState());
      } else {
        emit(PickImageErrorState('No image selected'));
      }
    } catch (e) {
      log(e.toString());
      emit(PickImageErrorState(e.toString()));
    }
    return image;
  }

  Future createUserToFireStore(
      {required UserModel userModel, required BuildContext context}) async {
    emit(LoginLoadingState());
    try {
      File compressedFile = await compressImage(context.read<LoginCubit>().image!);
      await storeFileToStorage("profilePic/${auth.currentUser!.uid}", compressedFile)
          .then((value) {
        String egyptPhoneNumberWithOutCountryCode =
            removeSubString(auth.currentUser!.phoneNumber!, '+2');
        userModel.phoneNumber = egyptPhoneNumberWithOutCountryCode;
        userModel.profilePic = value;
        userModel.userId = auth.currentUser!.phoneNumber!;
        emit(StoringUserFireStoreSuccessState());
      });
      // this.userModel = userModel;
      await firestore
          .collection('users')
          .doc(userModel.userId)
          .set(userModel.toJson())
          .then((value) async {
        await saveUserToSP().then((value) {
          setIsSignedInKeyToTrue();
        });
      });
    } catch (e) {
      log(e.toString());
      emit(StoringFireStoreErrorState(e.toString()));
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      log('storeFileToStorage$e');
      emit(StoringFireStoreErrorState(e.toString()));
      return '';
    }

  }

  Future saveUserToSP() async {
    try {
      String userJson = jsonEncode(userModel.toJson());
      await CacheHelper.saveData(
        key: userModelKey,
        value: userJson,
      );
      emit(CacheSaveUserModelState());
    } catch (e) {
      log(e.toString());
      emit(CacheFailureUserModelState(e.toString()));
    }
  }

  Future getUserFromCache() async {
    try {
      String data = await CacheHelper.getData(key: userModelKey);
      userModel = UserModel.fromJson(jsonDecode(data));
      log('getUserFromCache${userModel.userId}');
      emit(CacheGetUserModelState(userModel));
    } catch (e) {
      throw Exception('No user data in cache.');
    }
  }


}

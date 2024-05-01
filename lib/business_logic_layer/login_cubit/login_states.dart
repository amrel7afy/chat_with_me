import 'dart:developer';

import 'package:chat_with_me/data_layer/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class CacheSetSignedInToTrueState extends LoginStates {
  UserModel userModel;
  CacheSetSignedInToTrueState(this.userModel);
}

class CacheSignedOutState extends LoginStates {}
class CacheIsSignedInSuccessState extends LoginStates {}

class CacheOnBoardingSkipState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class OTPSentState extends LoginStates {
  String verificationId;

  OTPSentState(this.verificationId);
}

class OTPVerifiedState extends LoginStates {}

class LoginFailureState extends LoginStates {
  final String error;

  LoginFailureState(this.error);
}

class LoginFireBaseAuthErrorState extends LoginStates {
  final String error;

  LoginFireBaseAuthErrorState(this.error);
}

class LoginUserExistsState extends LoginStates {}

class LoginUserNotExistsState extends LoginStates {}

class PickImageSuccessState extends LoginStates {}

class PickImageErrorState extends LoginStates {
  String error;

  PickImageErrorState(this.error);
}

class StoringUserFireStoreSuccessState extends LoginStates {}

class StoringFireStoreErrorState extends LoginStates {
  String error;

  StoringFireStoreErrorState(this.error){log(error);}
}

class CacheSaveUserModelState extends LoginStates {}
class CacheGetUserModelState extends LoginStates {
  UserModel userModel;
  CacheGetUserModelState(this.userModel);
}

class CacheFailureUserModelState extends LoginStates {
  String error;

  CacheFailureUserModelState(this.error);
}

class CacheGetSignedInState extends LoginStates {
  UserModel userModel;

  CacheGetSignedInState(this.userModel);
}

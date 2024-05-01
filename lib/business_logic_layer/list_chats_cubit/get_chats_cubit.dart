import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/strings.dart';
import '../../data_layer/models/chat_model.dart';
import '../login_cubit/login_cubit.dart';

part 'get_chats_state.dart';

class GetChatsCubit extends Cubit<GetChatsState> {
  GetChatsCubit() : super(GetChatsInitial());

  static GetChatsCubit getCubit(BuildContext context) =>
      BlocProvider.of(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cubitFireStore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  List<ChatModel> userChats = [];

  getAllChats(BuildContext context) async {
    emit(GetChatsLoading());
    log('getAllChats');
    await LoginCubit.getCubit(context).getUserFromCache();
    log('userModel.userId:${userModel.userId}');

    try {
      var querySnapshot = await cubitFireStore
          .collection(kUserCollection)
          .doc(userModel.userId)
          .collection(kChatsCollection)
          .get();
      userChats = querySnapshot.docs
          .map((chatDoc) => ChatModel.fromJson(chatDoc.data()))
          .toList();
      log(userChats.first.name.toString());
      if (userChats.isEmpty) {
        emit(NoChatsState());
      }
      emit(GetUserChatsSuccessState(userChats));
    } catch (e) {
      log('getAllChats: $e');
      emit(NoChatsState());
     // emit(ChatGetUserChatsFailureState(e.toString()));
    }
  }
}

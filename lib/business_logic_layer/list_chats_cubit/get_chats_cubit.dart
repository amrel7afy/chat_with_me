import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/strings.dart';
import '../../data_layer/models/chat_model.dart';
import '../../data_layer/models/message_model.dart';
import '../chat_cubit/chat_states.dart';
import '../login_cubit/login_cubit.dart';

part 'get_chats_state.dart';

class GetChatsCubit extends Cubit<GetChatsState> {
  GetChatsCubit() : super(GetChatsInitial());



  static GetChatsCubit getCubit(BuildContext context) => BlocProvider.of(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cubitFireStore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  List<ChatModel> userChats=[];

  getAllChats(BuildContext context) async {
    emit(GetChatsLoading());
    log('getAllChats');
    await LoginCubit.getCubit(context).getUserFromCache();
    log('userModel.userId:${userModel.userId}');
    await cubitFireStore
        .collection(kUserCollection)
        .doc(userModel.userId)
        .collection(kChatsCollection)
        .get()
        .then((querySnapshot) async {
          userChats=querySnapshot.docs.map((chatDoc) =>ChatModel.fromJson(chatDoc.data())).toList();
      if(userChats.isEmpty){
        emit(NoChatsState());
      }
      emit(GetUserChatsSuccessState(userChats));
    }).catchError((e) {
      log('getAllChats: $e');
      emit(ChatGetUserChatsFailureState(e.toString()));
    });
  }

}

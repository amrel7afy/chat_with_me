import 'dart:core';
import 'dart:developer';

import 'package:chat_app/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/data_layer/models/chat_model.dart';
import 'package:chat_app/data_layer/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../constants/methods.dart';
import '../../data_layer/models/user_model.dart';

import 'chat_states.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  List<Contact> contacts = [];
  List<UserModel> users = [];
  List<UserModel> matchedUsersWithContacts = [];

  static ChatCubit getCubit(BuildContext context) => BlocProvider.of(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore cubitFireStore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  //UserModel userModel=getIt<UserModel>(instanceName: 'init');
/*  Future<UserModel> getUserModel(context)async{
    var dataIsExists=CacheHelper.getData(key: userModelKey);
    print(dataIsExists);
    if(dataIsExists!=null){
      print(dataIsExists);
     return userModel=UserModel.fromJson(jsonDecode(dataIsExists));
    }
    else{
      log('getUserModel');
      log(LoginCubit.getCubit(context).userModel.userId);
      return LoginCubit.getCubit(context).userModel;
    }
  }*/

  Future<List<Contact>> getContacts() async {
    // Request permission to access contacts
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        await ContactsService.getContacts().then((value) {
          contacts = value;
        });
        print(contacts[0].displayName);

        return contacts;
      } catch (ex) {
        throw Exception('You have no contacts');
      }
    } else {
      return [];
    }
  }

  getContactsWithException() async {
    try {
      await getContacts();
      emit(ChatGetContactsState(contacts));
    } catch (ex) {
      emit(ChatNoContactsState(removeSubString(ex.toString(), 'Exception: ')));
    }
  }

  Future getAllUsersFromFireStore() async {
    emit(ChatLoadingState());
    await cubitFireStore
        .collection(kUserCollection)
        .get()
        .then((querySnapshot) {
      addUsersFromStoreToUsersList(querySnapshot);

      emit(ChatGetUsersFromFireSuccessState());
    }).catchError((e) {
      log('ChatGetUsersFromFireFailureState: $e');
      emit(ChatGetUsersFromFireFailureState(e.toString()));
    });
  }

  addUsersFromStoreToUsersList(querySnapshot) {
    for (var element in querySnapshot.docs) {
      users.add(UserModel.fromJson(element.data()));
    }
  }

  List<UserModel?> getMatchedUsersWithContacts() {
    Set contactPhoneNumbers = contacts
        .expand((contact) => contact.phones ?? [])
        .map((phone) => phone.value ?? '')
        .toSet();
    if (contactPhoneNumbers.isNotEmpty) {
      matchedUsersWithContacts = users
          .where((user) => contactPhoneNumbers.contains(user.phoneNumber))
          .toList();

      return matchedUsersWithContacts;
    } else {
      return [];
    }
  }

  sendAMessage({required String recieverId, required String message}) async {
    MessageModel messageModel = MessageModel(
        message: message, id: recieverId, dateTime: DateTime.now().toString());

    //put message in my chat messages collection and my friend messages collection.
    CollectionReference userMessagesReference = cubitFireStore
        .collection(kUserCollection)
        .doc(userModel.userId)
        .collection(kChatsCollection)
        .doc(recieverId)
        .collection(kMessagesCollection);
    CollectionReference recieverMessagesReference = cubitFireStore
        .collection(kUserCollection)
        .doc(recieverId)
        .collection(kChatsCollection)
        .doc(userModel.userId)
        .collection(kMessagesCollection);

    await userMessagesReference.add(messageModel.toJson()).then((value) {
      recieverMessagesReference.add(messageModel.toJson());
      log('sendMessage: $message');
      // emit(ChatSendMessageSuccessState());
    }).catchError((e) {
      log('sendMessage: $e');
      emit(ChatSendMessageFailureState(e.toString()));
    });
  }



  List<MessageModel> messages = [];

  listenToMessages({required String recieverId, required context}) async {
    await LoginCubit.getCubit(context).getUserFromCache();
    emit(ChatLoadingState());
    try {
      cubitFireStore
          .collection(kUserCollection)
          .doc(userModel.userId)
          .collection(kChatsCollection)
          .doc(recieverId)
          .collection(kMessagesCollection)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .listen((event) {
        messages = event.docs
            .map((message) => MessageModel.fromJson(message.data()))
            .toList();
        log('messages: ${messages.length.toString()} Messages');
        emit(ChatListenMessagesSuccessState(messages));
        if (messages.isEmpty) {
          emit(NoMessagesState());
        }
      });
      log('returned messages: ${messages.length.toString()}');
      return messages;
    } catch (e) {
      log('getAndListenToMessages: $e');
      emit(ChatListenMessagesFailureState(e.toString()));
    }
  }

  listenToChats(context) async {
    await LoginCubit.getCubit(context).getUserFromCache();
    cubitFireStore
        .collection(kUserCollection)
        .doc(userModel.userId)
        .collection(kChatsCollection)
        .snapshots()
        .listen((event) {});
  }


}

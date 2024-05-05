import 'dart:developer';

import 'package:chat_with_me/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/strings.dart';
import '../../data_layer/models/message_model.dart';
import '../login_cubit/login_cubit.dart';
import 'listen_to_messages_state.dart';


class ListenToMessagesCubit extends Cubit<ListenToMessagesState> {
  ListenToMessagesCubit() : super(ListenToMessagesInitial());

  static ListenToMessagesCubit getCubit(BuildContext context) => BlocProvider.of(context);
  List<MessageModel> messages = [];
    String lastMessageDateTime='';

  listenToMessages({required String receiverId, required context}) async {
    await LoginCubit.getCubit(context).getUserFromCache();
    emit(ListenToMessagesLoadingState());

    try {
      locator<FirebaseFirestore>()
          .collection(kUserCollection)
          .doc(userModel.userId)
          .collection(kChatsCollection)
          .doc(receiverId)
          .collection(kMessagesCollection)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .listen((event) {
        messages = event.docs
            .map((message) => MessageModel.fromJson(message.data()))
            .toList();
        getTheTimeOfLastMessage();

        emit(ListenToMessagesSuccessState(messages));
        if (messages.isEmpty) {
          emit(NoListenMessagesState());
        }
      }
      );
      log('returned messages: ${  messages.length.toString()}');
      return messages;
    } catch (e) {
      log('getAndListenToMessages: $e');
      emit(ListenToMessagesFailureState(e.toString()));
    }
  }

  void getTheTimeOfLastMessage() {
    if (messages.isNotEmpty) {
      DateTime dateTime = DateTime.parse(messages[0].dateTime);
      // Formatting the DateTime to include AM/PM
      lastMessageDateTime = DateFormat('h:mm a').format(dateTime); // 'a' denotes AM/PM
      log(lastMessageDateTime);
    } else {
      log("No messages available.");
    }
  }
}

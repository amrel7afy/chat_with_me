
import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/data_layer/models/chat_model.dart';
import 'package:chat_with_me/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/strings.dart';
import '../../data_layer/models/user_model.dart';
import 'add_reciever_chat_data_state.dart';



class AddReceiverChatDataCubit extends Cubit<AddReceiverChatDataState> {
  //عشان نضيف بيانات الشخص اللي هتبعتله رساله ونسدعي الميثود مرة واحدة فقط
  bool isReceiverChatDataIsAdded = false;
  final FirebaseFirestore fireStore = locator<FirebaseFirestore>();

  AddReceiverChatDataCubit() : super(AddReceiverChatDataInitial());
  static AddReceiverChatDataCubit getCubit(BuildContext context) => BlocProvider.of(context);


   addReceiverChatData(UserModel receiverUserModel, context) async {
    LoginCubit.getCubit(context).getUserFromCache();
    ChatModel chatModel=ChatModel.fromUserModel(receiverUserModel);
    ChatModel myChatModel=ChatModel.fromUserModel(userModel);
      await fireStore
          .collection(kUserCollection)
          .doc(userModel.userId)
          .collection(kChatsCollection)
          .doc(receiverUserModel.userId)
          .set(chatModel.toJson());
    fireStore
        .collection(kUserCollection)
        .doc(receiverUserModel.userId)
        .collection(kChatsCollection)
        .doc(userModel.userId)
        .set(myChatModel.toJson())
          .then((value) {
            emit(AddReceiverChatDataToFireBaseSuccess());
      }).catchError((e){
        emit(ReceiverChatDataIsAddedToFireBaseFailure(e.toString()));
      });

  }

  updateUnreadMessagesCountOfReceiver({required String receiverId,required bool isOpened})async{
    DocumentReference receiverDoc = locator<FirebaseFirestore>()
        .collection(kUserCollection)
        .doc(receiverId)
        .collection(kChatsCollection)
        .doc(userModel.userId);
    int count;
     if(isOpened){
       count=0;
     }else{count=1;}

    await receiverDoc.update({'unreadMessagesCount': FieldValue.increment(count)}).then((value) {
      emit(UpdateUnreadMessagesCountSuccessState());
    }).catchError((e){
      log('updateUnreadMessagesCountOfReceiver: ${e.toString()}');
      emit(UpdateUnreadMessagesCountFailureState(e.toString()));
    });

  }


}

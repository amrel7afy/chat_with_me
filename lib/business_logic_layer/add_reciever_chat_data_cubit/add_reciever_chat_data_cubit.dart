
import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/login_cubit/login_cubit.dart';
import 'package:chat_with_me/data_layer/models/chat_model.dart';
import 'package:chat_with_me/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/strings.dart';
import '../../data_layer/models/user_model.dart';

part 'add_reciever_chat_data_state.dart';

class AddRecieverChatDataCubit extends Cubit<AddRecieverChatDataState> {
  //عشان نضيف بيانات الشخص اللي هتبعتله رساله ونسدعي الميثود مرة واحدة فقط
  bool isRecieverChatDataIsAdded = false;
  final FirebaseFirestore fireStore = locator<FirebaseFirestore>();

  AddRecieverChatDataCubit() : super(AddRecieverChatDataInitial());
  static AddRecieverChatDataCubit getCubit(BuildContext context) => BlocProvider.of(context);

   /*checkRecieverChatDataIsAdded() async {
    isRecieverChatDataIsAdded =
        await CacheHelper.getData(key: isRecieverChatDataIsAddedKey) ?? false;
    if (isRecieverChatDataIsAdded) {
      emit(RecieverChatDataIsAddedBefore());
    }
  }

  Future setIsRecieverChatDataIsAddedKeyToTrue() async {
    await CacheHelper.saveData(key: isRecieverChatDataIsAddedKey, value: true);
  }*/

   addReceiverChatData(UserModel recieverUserModel, context) async {
    LoginCubit.getCubit(context).getUserFromCache();
    ChatModel chatModel=ChatModel.fromUserModel(recieverUserModel);
      await fireStore
          .collection(kUserCollection)
          .doc(userModel.userId)
          .collection(kChatsCollection)
          .doc(recieverUserModel.userId)
          .set(chatModel.toJson())
          .then((value) {
            emit(AddRecieverChatDataToFireBaseSuccess());
      }).catchError((e){
        emit(RecieverChatDataIsAddedToFireBaseFailure(e.toString()));
      });

  }

  updateUnreadMessagesCountOfReciever({required String recieverId})async{
    DocumentReference recieverDoc = locator<FirebaseFirestore>()
        .collection(kUserCollection)
        .doc(recieverId)
        .collection(kChatsCollection)
        .doc(userModel.userId);
    await recieverDoc.update({'unreadMessagesCount': FieldValue.increment(1)}).then((value) {
      emit(UpdateUnreadMessagesCountSuccessState());
    }).catchError((e){
      log('updateUnreadMessagesCountOfReceiver: ${e.toString()}');
      emit(UpdateUnreadMessagesCountFailureState(e.toString()));
    });

  }


}

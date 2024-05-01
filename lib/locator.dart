import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'business_logic_layer/add_reciever_chat_data_cubit/add_reciever_chat_data_cubit.dart';
import 'business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'business_logic_layer/login_cubit/login_cubit.dart';
import 'data_layer/models/user_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<UserModel>(() => UserModel.init(), instanceName: 'init');
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  locator.registerLazySingleton<AddRecieverChatDataCubit>(() => AddRecieverChatDataCubit());
  locator.registerLazySingleton<ListenToMessagesCubit>(() => ListenToMessagesCubit());
  locator.registerLazySingleton<LoginCubit>(() => LoginCubit());
}
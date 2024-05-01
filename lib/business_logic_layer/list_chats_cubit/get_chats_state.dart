part of 'get_chats_cubit.dart';

@immutable
abstract class GetChatsState {}

class GetChatsInitial extends GetChatsState {}

class GetChatsLoading extends GetChatsState{}

class GetUserChatsSuccessState extends GetChatsState {
  final List<ChatModel> chats;
  GetUserChatsSuccessState(this.chats);
}

class NoChatsState extends GetChatsState {}

class ChatGetUserChatsFailureState extends GetChatsState {
  final String error;

  ChatGetUserChatsFailureState(this.error){log(error.toString());}
}

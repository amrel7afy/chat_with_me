import 'package:contacts_service/contacts_service.dart';

import '../../data_layer/models/chat_model.dart';
import '../../data_layer/models/message_model.dart';

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}
class ChatLoadingState extends ChatStates {}

class ChatGetContactsState extends ChatStates {
  List<Contact> contacts;

  ChatGetContactsState(this.contacts);
}

class ChatNoContactsState extends ChatStates {

  String error;

  ChatNoContactsState(this.error);
}
class ChatGetUsersFromFireSuccessState extends ChatStates{}


class ChatGetUsersFromFireFailureState extends ChatStates {

  String error;

  ChatGetUsersFromFireFailureState(this.error);
}


class ChatSendMessageSuccessState extends ChatStates{}


class ChatSendMessageFailureState extends ChatStates {

  String error;

  ChatSendMessageFailureState(this.error);
}
class ChatListenMessagesSuccessState extends ChatStates{
  List<MessageModel>messages;

  ChatListenMessagesSuccessState(this.messages);
}
class NoMessagesState extends ChatStates{}


class ChatListenMessagesFailureState extends ChatStates {

  String error;

  ChatListenMessagesFailureState(this.error);
}


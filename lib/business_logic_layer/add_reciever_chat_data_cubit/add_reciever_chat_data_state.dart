part of 'add_reciever_chat_data_cubit.dart';

@immutable
abstract class AddRecieverChatDataState {}

class AddRecieverChatDataInitial extends AddRecieverChatDataState {}

class RecieverChatDataIsAddedBefore extends AddRecieverChatDataState {}

class LoadingRecieverChatDataIsAdded extends AddRecieverChatDataState {}

class AddRecieverChatDataToFireBaseSuccess extends AddRecieverChatDataState {}

class RecieverChatDataIsAddedToFireBaseFailure
    extends AddRecieverChatDataState {
  final String error;

  RecieverChatDataIsAddedToFireBaseFailure(this.error);
}
class UpdateUnreadMessagesCountSuccessState extends AddRecieverChatDataState {

}

class UpdateUnreadMessagesCountFailureState extends AddRecieverChatDataState {

  final String error;

  UpdateUnreadMessagesCountFailureState(this.error);
}
//class RecieverChatDataAddedFailure extends AddRecieverChatDataState {}



abstract class AddReceiverChatDataState {}

class AddReceiverChatDataInitial extends AddReceiverChatDataState {}

class ReceiverChatDataIsAddedBefore extends AddReceiverChatDataState {}

class LoadingReceiverChatDataIsAdded extends AddReceiverChatDataState {}

class AddReceiverChatDataToFireBaseSuccess extends AddReceiverChatDataState {}

class ReceiverChatDataIsAddedToFireBaseFailure
    extends AddReceiverChatDataState {
  final String error;

  ReceiverChatDataIsAddedToFireBaseFailure(this.error);
}
class UpdateUnreadMessagesCountSuccessState extends AddReceiverChatDataState {

}

class UpdateUnreadMessagesCountFailureState extends AddReceiverChatDataState {

  final String error;

  UpdateUnreadMessagesCountFailureState(this.error);
}
//class ReceiverChatDataAddedFailure extends AddReceiverChatDataState {}

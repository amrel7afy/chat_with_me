

abstract class UnreadMessagesCountState {}

class UnreadMessagesCountInitial extends UnreadMessagesCountState {}
class ExistsUnreadMessagesState extends UnreadMessagesCountState {

  final int unreadCount;

  ExistsUnreadMessagesState(this.unreadCount);
}
class NotExistsUnreadMessagesState extends UnreadMessagesCountState {
}class UnreadMessagesErrorState extends UnreadMessagesCountState {
  final String error;

  UnreadMessagesErrorState(this.error);
}

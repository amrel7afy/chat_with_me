import 'package:chat_with_me/data_layer/models/user_model.dart';
import 'package:contacts_service/contacts_service.dart';

 class CheckContactsState {}

 class CheckContactsInitial extends CheckContactsState {}
 class CheckContactsLoading extends CheckContactsState {}

class CheckGetContactsState extends CheckContactsState {
  List<UserModel> contacts;

  CheckGetContactsState(this.contacts);
}

class CheckNoContactsState extends CheckContactsState {
  String error;

  CheckNoContactsState(this.error);
}

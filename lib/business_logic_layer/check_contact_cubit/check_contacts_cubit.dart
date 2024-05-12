
import 'package:chat_with_me/constants/strings.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/methods.dart';
import '../../data_layer/models/user_model.dart';
import '../chat_cubit/chat_cubit.dart';
import 'check_contacts_state.dart';

class CheckContactsCubit extends Cubit<CheckContactsState> {
  CheckContactsCubit() : super(CheckContactsInitial());
  List<Contact> contacts = [];
  List<UserModel> matchedUsersWithContacts = [];

  getContacts() async {
    // Request permission to access contacts
    emit(CheckContactsLoading());
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        await ContactsService.getContacts().then((value) {
          contacts = value;
        });
      } catch (ex) {
        emit(CheckNoContactsState(
            removeSubString(ex.toString(), 'Exception: ')));
      }
    } else {
      return [];
    }
  }

  getMatchedUsersWithContacts(BuildContext context) {
    Set contactPhoneNumbers = contacts
        .expand((contact) => contact.phones ?? [])
        .map((phone) => _cleanPhoneNumber(phone.value) ?? '')
        .toSet();

    if (contactPhoneNumbers.isNotEmpty) {
      matchedUsersWithContacts = context
          .read<ChatCubit>()
          .users
          .where((user) => contactPhoneNumbers.contains(user.phoneNumber))
          .toList();
      removeCurrentUserFromList();
      if (matchedUsersWithContacts.isEmpty) {
        emit(CheckNoMatchedContactsState(
            'Hmm 😐, you can invite your contacts to our app! '));
      } else {
        emit(CheckGetContactsSuccessState(matchedUsersWithContacts));
      }
    } else {
      emit(CheckNoContactsState('Hmm 😐, you need to save a new contact. '));
    }
  }

  void removeCurrentUserFromList() {
    List<UserModel>filteredList=List.from(matchedUsersWithContacts);
    for (var user in filteredList) {
      if(user.phoneNumber==userModel.phoneNumber){
        matchedUsersWithContacts.remove(user);
      }
    }
  }

  String _cleanPhoneNumber(String phoneNumber) {
    // Remove spaces and dashes from phone number
    return phoneNumber.replaceAll(RegExp(r'[ -]'), '');
  }
}

import 'dart:developer';

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
        .map((phone) => phone.value ?? '')
        .toSet();

    if (contactPhoneNumbers.isNotEmpty) {

      matchedUsersWithContacts = context
          .read<ChatCubit>()
          .users
          .where((user) => contactPhoneNumbers.contains(user.phoneNumber))
          .toList();
      emit(CheckGetContactsState(matchedUsersWithContacts));
    } else {
      emit(CheckNoContactsState('Hmm 😐, you need to save a new contact. '));
    }
  }
}

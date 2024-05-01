import 'dart:developer';

import 'package:chat_with_me/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:chat_with_me/business_logic_layer/check_contact_cubit/check_contacts_cubit.dart';

import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:chat_with_me/constants/strings.dart';

import 'package:chat_with_me/presentation_layer/pages_widgets/contact_builder.dart';
import 'package:chat_with_me/presentation_layer/widgets/custom_error_message.dart';

import 'package:chat_with_me/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic_layer/chat_cubit/chat_states.dart';
import '../../business_logic_layer/check_contact_cubit/check_contacts_state.dart';
import '../widgets/loading_indicator.dart';

class ContactsPage extends StatefulWidget {
  //UserModel userModel=getIt<UserModel>(instanceName: 'init');
  //UserModel? userModel;
  const ContactsPage({
    super.key,
  });

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    getContacts().then((value) => context
        .read<CheckContactsCubit>()
        .getMatchedUsersWithContacts(context));
    super.initState();
  }

  Future<void> getContacts() async {
    await context.read<CheckContactsCubit>().getContacts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select a contact',
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<CheckContactsCubit, CheckContactsState>(
          builder: (BuildContext context, state) {


            if (state is CheckNoContactsState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: CustomErrorMessage(text: state.error),
              );
            } else if (state is CheckGetContactsState) {
              return ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  if(state.contacts[index].phoneNumber==userModel.phoneNumber){
                    return Container();
                  }else{
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, messagingPage,
                          arguments: context
                              .read<CheckContactsCubit>()
                              .matchedUsersWithContacts[index]);
                    },
                    child: ContactItemBuilder(
                      userModel: state.contacts[index],
                    ),
                  );
                }},
                itemCount: state.contacts.length,
              );
            } else {
              return const CustomLoadingIndicator();
            }
          },
        ));
  }

  Center buildNoContactWidget(state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.error,
            style: MyTextStyles.headLine4.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildOfflineBuilder() {
    return const Center(
      child: Text(
        'NO INTERNET..',
        style: MyTextStyles.headLine3,
      ),
    );
  }
}

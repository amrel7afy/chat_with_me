import 'dart:developer';

import 'package:chat_app/business_logic_layer/chat_cubit/chat_cubit.dart';

import 'package:chat_app/constants/my_text_styles.dart';
import 'package:chat_app/constants/strings.dart';

import 'package:chat_app/presentation_layer/pages_widgets/contact_builder.dart';

import 'package:chat_app/presentation_layer/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic_layer/chat_cubit/chat_states.dart';
import '../pages_widgets/signout_button.dart';
import '../widgets/loading_indicator.dart';

class ChatPage extends StatefulWidget {
  //UserModel userModel=getIt<UserModel>(instanceName: 'init');
  //UserModel? userModel;
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  const Text('Select a contact',),
            automaticallyImplyLeading:false,
          actions: [
            BlocBuilder<ChatCubit, ChatStates>(builder: (context, state) {
              return const SignOutButton();
            })
          ],
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return buildBlocBody();
            } else {
              return buildOfflineBuilder();
            }
          },
          child: const CustomLoadingIndicator(),
        ));
  }

  Widget buildBlocBody() {
    return BlocConsumer<ChatCubit, ChatStates>(
      builder: (BuildContext context, state) {
       ChatCubit.getCubit(context).getMatchedUsersWithContacts();
        if (ChatCubit.getCubit(context).matchedUsersWithContacts.isNotEmpty) {
          log(ChatCubit.getCubit(context)
              .matchedUsersWithContacts
              .length
              .toString());
          return ListView.builder(
            itemBuilder: (BuildContext context, index) => GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, messagingPage,arguments: ChatCubit.getCubit(context).matchedUsersWithContacts[index]);
              },
              child: ContactItemBuilder(
                userModel:
                    ChatCubit.getCubit(context).matchedUsersWithContacts[index],
              ),
            ),
            itemCount:
                ChatCubit.getCubit(context).matchedUsersWithContacts.length,
          );
        }
        else if (state is ChatNoContactsState) {
          return const Center(
            child:  Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Hmm 😐, you need to save a new contact. ',style: MyTextStyles.headLine3,),

                ],
              ),
            ),
          );
        }
        else{
        return  const CustomLoadingIndicator();
        }

      },
      listener: (BuildContext context, ChatStates state) {
        if (state is ChatNoContactsState) {
          showSnackBar(context, state.error);
        }
      },
    );
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
    return Container(
      child: const Center(
        child: Text('NO INTERNET..',style: MyTextStyles.headLine3,),
      ),
    );
  }


}



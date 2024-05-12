
import 'package:chat_with_me/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:chat_with_me/business_logic_layer/list_chats_cubit/get_chats_cubit.dart';
import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:chat_with_me/constants/strings.dart';

import 'package:chat_with_me/presentation_layer/pages_widgets/chat_item_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/unread_messages_count/unread_messages_count_cubit.dart';
import '../../data_layer/cache_helper.dart';
import '../pages_widgets/custom_floating_button.dart';
import '../widgets/custom_error_message.dart';
import '../widgets/loading_indicator.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetChatsCubit>().getAllChats(context);
    context.read<ChatCubit>().getAllUsersFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chats'),
        actions: const [
          PopUpMenu(),
        ],
      ),
      body: BlocBuilder<GetChatsCubit, GetChatsState>(
        builder: (BuildContext context, state) {
          if (state is GetChatsLoading) {
            return const CustomLoadingIndicator();
          } else if (state is GetUserChatsSuccessState) {

            if (state.chats.isEmpty) {
              return const CustomErrorMessage(
                text: 'No Chats',
              );
            } else {
              return   ChatSuccessBody(state: state);
            }
          } else if (state is ChatGetUserChatsFailureState) {
            return CustomErrorMessage(
              text: state.error,
            );
          }
          else if(state is NoChatsState) {
            return const CustomErrorMessage(
              text: 'No Chats',
            );

          }else{
            return const CustomLoadingIndicator();
          }
          }

      ),
      floatingActionButton: const CustomFloatingAction(),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'Profile') {
          Navigator.pushNamed(context, editProfilePage,
              arguments: userModel);
        } else {
          ChatCubit.getCubit(context).auth.signOut().then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, logInPage, (route) => false);
            CacheHelper.removeData(key: userModelKey);
            CacheHelper.removeData(key: isSignedInKey);
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          height: 50,
          value: 'Profile',
          child: Text(
            'Profile',
            style: MyTextStyles.headLine4,
          ),
        ),
        const PopupMenuItem<String>(
          height: 50,
          value: 'Log Out',
          child: Text('Log Out', style: MyTextStyles.headLine4),
        ),
      ],
    );
  }
}

class ChatSuccessBody extends StatelessWidget {
  final GetUserChatsSuccessState state;
  const ChatSuccessBody({
    super.key, required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.chats.length,
      itemBuilder: (context, index) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ListenToMessagesCubit()),
          BlocProvider(
              create: (context) => UnreadMessagesCountCubit()),
        ],
        child: state.chats[index].phoneNumber == userModel.phoneNumber
            ? Container()
            : InkWell(
                onTap: () {
                  Navigator.pushNamed(context, messagingPage,
                      arguments:
                          context.read<ChatCubit>().users[index]);
                },
                child:
                    ChatItemBuilder(chatModel: state.chats[index])),
      ),
    );
  }
}

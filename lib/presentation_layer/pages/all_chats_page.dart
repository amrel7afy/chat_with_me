import 'dart:developer';

import 'package:chat_app/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:chat_app/business_logic_layer/list_chats_cubit/get_chats_cubit.dart';
import 'package:chat_app/business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'package:chat_app/constants/my_text_styles.dart';
import 'package:chat_app/locator.dart';

import 'package:chat_app/presentation_layer/pages_widgets/chat_item_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/chat_cubit/chat_states.dart';

import '../../business_logic_layer/unread_messages_count/unread_messages_count_cubit.dart';
import '../../data_layer/models/chat_model.dart';
import '../pages_widgets/custom_floating_button.dart';
import '../widgets/custom_error_message.dart';
import '../widgets/loading_indicator.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetChatsCubit>().getAllChats(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chats'),
      ),
      body: BlocBuilder<GetChatsCubit, GetChatsState>(
        builder: (BuildContext context, state) {
          if (state is GetChatsLoading) {
            return const CustomLoadingIndicator();
          } else if (state is GetUserChatsSuccessState) {
            return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) =>
                    MultiBlocProvider(
                      providers: [
                       BlocProvider(create: (context) => ListenToMessagesCubit()) ,
                       BlocProvider(
                           lazy: false,
                           create: (context) => UnreadMessagesCountCubit()) ,
                      ],
                      child: ChatItemBuilder(chatModel: state.chats[index]),
                    ));
          }
          else if (state is ChatGetUserChatsFailureState) {
            return CustomErrorMessage(state: state,);
          }
          else {
            return Container(width: 200, height: 300, color: Colors.red,);
          }
        },
      ),
      floatingActionButton: const CustomFloatingAction(),
    );
  }
}



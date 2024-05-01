
import 'package:chat_with_me/business_logic_layer/add_reciever_chat_data_cubit/add_reciever_chat_data_cubit.dart';
import 'package:chat_with_me/business_logic_layer/chat_cubit/chat_cubit.dart';
import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_state.dart';
import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:chat_with_me/data_layer/models/user_model.dart';
import 'package:chat_with_me/locator.dart';
import 'package:chat_with_me/presentation_layer/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/chat_cubit/chat_states.dart';
import '../../data_layer/models/message_model.dart';
import '../pages_widgets/chat_bubbles.dart';
import '../pages_widgets/getEitherNetworkImageAvatarOrAssetImage.dart';

class MessagingPage extends StatefulWidget {
  final UserModel friendModel;

  const MessagingPage({super.key, required this.friendModel});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  TextEditingController messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    ChatCubit.getCubit(context).listenToMessages(recieverId: '+2${widget.friendModel.phoneNumber}', context: context);
    AddRecieverChatDataCubit.getCubit(context).addReceiverChatData(widget.friendModel, context);
    super.initState();
  }

  @override
  void dispose() {
    locator<AddRecieverChatDataCubit>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatCubit.getCubit(context).listenToMessages(
        recieverId: '+2${widget.friendModel.phoneNumber}', context: context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.friendModel.name),
        leading: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: MyColors.kPrimaryColor,
                  ),
                  getEitherNetworkImageAvatarOrAssetImage(
                      radius: 15,
                      noProfileRadius: 16,
                      userModel: widget.friendModel)
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatStates>(builder: (context, state) {
        List<MessageModel> messages = ChatCubit.getCubit(context).messages;
        if (state is ChatLoadingState) {
          return const CustomLoadingIndicator();
        } else if (state is NoMessagesState) {
          return Column(
            children: [
              buildTextMessage('Send message now!'),
              buildMessageSender()
            ],
          );
        } else {
          return Column(
              children: [
                BlocBuilder<AddRecieverChatDataCubit,AddRecieverChatDataState>(builder: (context,state){
                  return Container(height: 0.00001,);
                }),
                BlocBuilder<ListenToMessagesCubit,ListenToMessagesState>(builder: (context,state){
                  return Container(height: 0.00001,);
                }),
            if (state is ChatListenMessagesSuccessState)Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMyMessage =
                          message.id == widget.friendModel.userId;
                      return isMyMessage
                          ? MyChatBubble(messageModel: message)
                          : OtherChatBubble(messageModel: message);
                    },
                    itemCount: messages.length // Add 1 for the extra container
                    ),
              ),
            if (state is! ChatListenMessagesSuccessState)buildTextMessage('Some thing wrong!'),
            buildMessageSender()
          ]);
        }
      }),
    );
  }

  Widget buildTextMessage(message) {
    return Expanded(
        child: Center(
          child: Text(
            message,
            style: MyTextStyles.headLine2,
          ),
        ),
      );
  }

  Widget buildMessageSender() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 3, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorHeight: 23,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle:
                TextStyle(color: Colors.grey[400], fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        buildSenderIconButton(),
        const SizedBox()
      ],
    );
  }

  Widget buildSenderIconButton() {
    return BlocBuilder<ChatCubit, ChatStates>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (messageController.text.isNotEmpty) {
              ChatCubit.getCubit(context).sendAMessage(
                  recieverId: widget.friendModel.userId,
                  message: messageController.text.trim());
              context.read<AddRecieverChatDataCubit>().updateUnreadMessagesCountOfReciever(recieverId: widget.friendModel.userId);
            }
            setState(() {
              messageController.clear();
            });
            if(ListenToMessagesCubit.getCubit(context).messages.isNotEmpty){
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.bounceOut);
          }},
          child: const CircleAvatar(
            radius: 23,
            child: Icon(
              Icons.send,
              color: MyColors.kPrimaryColor,
            ),
          ),
        ),
      );
    });
  }
}

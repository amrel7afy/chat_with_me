import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_cubit.dart';
import 'package:chat_with_me/business_logic_layer/listen_to_messages_cubit/listen_to_messages_state.dart';

import 'package:chat_with_me/constants/my_colors.dart';
import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../business_logic_layer/unread_messages_count/unread_messages_count_cubit.dart';
import '../../business_logic_layer/unread_messages_count/unread_messages_count_state.dart';
import '../../data_layer/models/chat_model.dart';
import 'no_profile_image_avatar.dart';

class ChatItemBuilder extends StatefulWidget {
  final ChatModel chatModel;

  const ChatItemBuilder({super.key, required this.chatModel});

  @override
  State<ChatItemBuilder> createState() => _ChatItemBuilderState();
}

class _ChatItemBuilderState extends State<ChatItemBuilder> {
  final String defaultProfileNetworkImage =
      'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.nicepng.com%2Fpng%2Fdetail%2F933-9332131_profile-picture-default-png.png&tbnid=bLv2FccUvqriEM&vet=10CAYQxiAoB2oXChMI-OCPhr3cgwMVAAAAAB0AAAAAEAc..i&imgrefurl=https%3A%2F%2Fwww.nicepng.com%2Fourpic%2Fu2y3a9e6t4o0a9w7_profile-picture-default-png%2F&docid=-E5pvHnffveX2M&w=820&h=719&itg=1&q=profile%20image%20png&ved=0CAYQxiAoB2oXChMI-OCPhr3cgwMVAAAAAB0AAAAAEAc';


  @override
  void initState() {
    ListenToMessagesCubit.getCubit(context).listenToMessages(
        receiverId: '+2${widget.chatModel.phoneNumber}', context: context);
    context.read<UnreadMessagesCountCubit>().listenToUnreadMessagesCount(receiverId: '+2${widget.chatModel.phoneNumber}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenToMessagesCubit, ListenToMessagesState>(
      builder: (context, state) {
        if (state is ListenToMessagesSuccessState) {}
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatModel.name,
                style: MyTextStyles.headLine4
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              if (state is ListenToMessagesSuccessState)
                Text(
                  state.messages[0].message,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextStyles.smallBody,
                )
            ],
          ),
          leading: widget.chatModel.profilePic.isEmpty
              ? const NoChatProfileImageAvatar()
              : CircleAvatar(
                  radius: 25,
                  backgroundColor: MyColors.kPrimaryColor,
                  backgroundImage: NetworkImage(widget.chatModel.profilePic)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.read<ListenToMessagesCubit>().lastMessageDateTime,
                style: MyTextStyles.smallBody,
              ),
              const UnReadMessagesBloc(),

            ],
          ),
        );
      },
    );
  }
}

class UnReadMessagesBloc extends StatelessWidget {
  const UnReadMessagesBloc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadMessagesCountCubit, UnreadMessagesCountState>(
      builder: (context, state) {
        if(state is ExistsUnreadMessagesState){
        return buildUnReadMessageAvatar(state);}
        else{
          return CircleAvatar(
            radius: 8,
            backgroundColor: MyColors.kGifBackGroundColor,
            child: Container()
          );
        }
      },
    );
  }



  CircleAvatar buildUnReadMessageAvatar(ExistsUnreadMessagesState state) {
    double radius;
    if(state.unreadCount>9){
      radius=10.0;
    }else{
      radius=8.0;
    }
    return CircleAvatar(
        radius: radius,
        backgroundColor: MyColors.kPrimaryColor,
        child: Text(
          state.unreadCount.toString(),
          style: MyTextStyles.smallBody.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900),
        ),
      );
  }
}

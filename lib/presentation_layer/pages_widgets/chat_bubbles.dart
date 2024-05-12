import 'package:chat_with_me/constants/my_text_styles.dart';
import 'package:chat_with_me/data_layer/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

import '../../constants/my_colors.dart';

class OtherChatBubble extends StatelessWidget {
  final MessageModel messageModel;

  const OtherChatBubble({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(messageModel.dateTime);
    return ChatBubble(
      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: MyColors.kPrimaryColor.withOpacity(0.45),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${messageModel.message} ',
              style: MyTextStyles.messageTestStyle,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(dateTime),
                  style: MyTextStyles.messageTestStyle
                      .copyWith(fontSize: 10, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 3,),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyChatBubble extends StatelessWidget {
  final MessageModel messageModel;

  const MyChatBubble({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(messageModel.dateTime);
    return ChatBubble(
      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: MyColors.kPrimaryColor,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${messageModel.message} ',
              style: MyTextStyles.messageTestStyle,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(dateTime),
                  style: MyTextStyles.messageTestStyle
                      .copyWith(fontSize: 10, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 3,),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

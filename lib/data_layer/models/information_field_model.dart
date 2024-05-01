import 'package:chat_with_me/constants/my_colors.dart';
import 'package:flutter/material.dart';

class InformationFieldModel {
  final String hint;
  final Icon icon;
  int? maxLines;
  final controller;

  InformationFieldModel(
      {required this.hint, required this.icon, this.maxLines, this.controller});
}

List<InformationFieldModel> fieldModels = [
  InformationFieldModel(
      hint: 'Enter your name',
      icon: const Icon(
        Icons.account_circle_rounded,
        size: 25,
        color: MyColors.kPrimaryColor,
      ),controller: TextEditingController()),
  InformationFieldModel(
      hint: 'abc@example.com',
      icon: const Icon(
        Icons.email_outlined,
        size: 25,
      ),controller: TextEditingController()),
  InformationFieldModel(
      hint: 'Enter your bio here',
      icon: const Icon(
        Icons.edit,
        size: 25,
      ),
      maxLines: 2,controller: TextEditingController()),
];

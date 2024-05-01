import 'package:chat_with_me/data_layer/models/user_model.dart';

class ChatModel {
  final String phoneNumber;
  final String name;
  final String profilePic;
  int unreadMessagesCount;

  ChatModel(
      {required this.name,
      required this.phoneNumber,
      required this.profilePic,
      required this.unreadMessagesCount});

  ChatModel.fromUserModel(UserModel userModel)
      : phoneNumber = userModel.phoneNumber,
        name = userModel.name,
        profilePic = userModel.profilePic,
        unreadMessagesCount = 0;

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final phoneNumber = json['phoneNumber'];
    final name = json['name'];
    final profilePic = json['profilePic'];
    final unreadMessagesCount = json['unreadMessagesCount'];

    if (phoneNumber is! String) {
      throw FormatException(
          'Invalid JSON: required "phoneNumber" field of type String in $json');
    }
    if (name is! String) {
      throw FormatException(
          'Invalid JSON: required "name" field of type String in $json');
    }
    if (profilePic is! String) {
      throw FormatException(
          'Invalid JSON: required "profilePic" field of type String in $json');
    }

    return ChatModel(
        phoneNumber: phoneNumber,
        name: name,
        profilePic: profilePic,
        unreadMessagesCount: unreadMessagesCount);
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'profilePic': profilePic,
      'unreadMessagesCount':unreadMessagesCount
    };
  }
}

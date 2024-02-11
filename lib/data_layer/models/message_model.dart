class MessageModel {
  late String id;
  late String message;
  late String dateTime;

  MessageModel(
      {required this.message, required this.id, required this.dateTime});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String) {
      throw FormatException(
          'Invalid JSON: required "id" field of type String in $json');
    }
    final message = json['message'];
    if (message is! String) {
      throw FormatException(
          'Invalid JSON: required "message" field of type String in $json');
    }

    final dateTime = json['dateTime'];

    return MessageModel(id: id, dateTime: dateTime, message: message);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'dateTime': dateTime,
    };
  }
}

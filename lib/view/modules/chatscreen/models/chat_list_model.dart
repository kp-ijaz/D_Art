import 'dart:convert';

ChatListModel chatListModelFromJson(String str) =>
    ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  int? statusCode;
  String? message;
  List<Datum>? data;

  ChatListModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        statusCode: json["status_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? userId;
  String? image;
  String? name;
  String? email;
  String? phone;
  String? lastMessage;

  Datum({
    this.userId,
    this.image,
    this.name,
    this.email,
    this.phone,
    this.lastMessage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["userId"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        lastMessage: json["last_message"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "image": image,
        "name": name,
        "email": email,
        "phone": phone,
        "last_message": lastMessage,
      };
}

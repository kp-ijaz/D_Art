import 'dart:convert';

MessagesModel messagesModelFromJson(String str) =>
    MessagesModel.fromJson(json.decode(str));

String messagesModelToJson(MessagesModel data) => json.encode(data.toJson());

class MessagesModel {
  int? statusCode;
  String? message;
  List<Datum>? data;

  MessagesModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
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
  int? isFile;
  FileType? fileType;
  String? message;
  String? time;
  Date? date;

  Datum({
    this.userId,
    this.isFile,
    this.fileType,
    this.message,
    this.time,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["userId"],
        isFile: json["is_file"],
        fileType: fileTypeValues.map[json["file_type"]]!,
        message: json["message"],
        time: json["time"],
        date: dateValues.map[json["date"]]!,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "is_file": isFile,
        "file_type": fileTypeValues.reverse[fileType],
        "message": message,
        "time": time,
        "date": dateValues.reverse[date],
      };
}

enum Date { THE_03082023, THE_04082023 }

final dateValues = EnumValues(
    {"03-08-2023": Date.THE_03082023, "04-08-2023": Date.THE_04082023});

enum FileType { NONE }

final fileTypeValues = EnumValues({"none": FileType.NONE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

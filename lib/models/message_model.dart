// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

List<Message> messageFromJson(String str) =>
    List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  String senderId;
  String text;
  DateTime createdAt;

  Message({
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json["senderId"],
        text: json["text"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "text": text,
        "createdAt": createdAt.toIso8601String(),
      };
}

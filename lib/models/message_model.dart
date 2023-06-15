// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

List<Message> messageFromJson(String str) =>
    List<Message>.from(json.decode(str).map((x) => Message.fromJson(x)));

String messageToJson(List<Message> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Message {
  String chatId;
  String senderId;
  String text;

  Message({
    required this.chatId,
    required this.senderId,
    required this.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        chatId: json["chatId"],
        senderId: json["senderId"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "senderId": senderId,
        "text": text,
      };
}

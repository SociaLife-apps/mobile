// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<Chat> chatFromJson(String str) =>
    List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
  String id;
  List<String> members;

  Chat({
    required this.id,
    required this.members,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["_id"],
        members: List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "members": List<dynamic>.from(members.map((x) => x)),
      };
}

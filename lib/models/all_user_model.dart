// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<AllUser> allUserFromJson(String str) =>
    List<AllUser>.from(json.decode(str).map((x) => AllUser.fromJson(x)));

String allUserToJson(List<AllUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllUser {
  String id;
  String username;

  AllUser({
    required this.id,
    required this.username,
  });

  factory AllUser.fromJson(Map<String, dynamic> json) => AllUser(
        id: json["_id"],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  UserClass user;
  String token;

  User({
    required this.user,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class UserClass {
  String id;
  String username;
  List<dynamic> friends;

  UserClass({
    required this.id,
    required this.username,
    required this.friends,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["_id"],
        username: json["username"],
        friends: List<dynamic>.from(json["friends"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "friends": List<dynamic>.from(friends.map((x) => x)),
      };
}

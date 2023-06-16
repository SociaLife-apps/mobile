// ignore_for_file: dead_code, prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/chat_controller.dart';
import 'package:socialife_mobile/models/all_user_model.dart';
import 'package:socialife_mobile/models/user_model.dart';
import 'package:socialife_mobile/screens/home.dart';
import 'package:socialife_mobile/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  ChatController chatController = Get.put(ChatController());
  TextEditingController friendController = TextEditingController();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getUser(String id) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.getUser + id);

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        User user = userFromJson(response.body);

        return user.username;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error ocured";
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("error"),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }

  Future getAllUser() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.getAllUser);

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<AllUser> userList = allUserFromJson(response.body);

        return userList;
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("error"),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }

  Future<void> addFriend(String id) async {
    try {
      List<AllUser> users = await getAllUser();
      String findUser = friendController.text;
      String idFound = 'false';

      for (AllUser user in users) {
        if (user.username == findUser) {
          idFound = user.id;
          break;
        }
      }
      print(idFound);
      if (idFound != 'false') {
        var headers = {'Content-Type': 'application/json'};
        print('test');
        var url = Uri.parse(ApiEndpoints.baseUrl +
            ApiEndpoints.authEndPoints.addFriend +
            idFound + '/add');
        print(url);

        Map body = {'_id': id};
        print(body);

        http.Response response =
            await http.put(url, body: jsonEncode(body), headers: headers);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(await chatController.createChat(id, idFound));
        }
      }

      friendController.clear();
      Get.off(HomeScreen());

    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("error"),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}

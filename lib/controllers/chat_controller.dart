// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialife_mobile/models/chat_model.dart';
import 'package:socialife_mobile/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
// import 'package:socialife_mobile/models/chat_model.dart';

class ChatController extends GetxController {

  Future createChat(String senderId, receiverId) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.createChat);
      Map body = {
        'senderId': senderId,
        'receiverId': receiverId,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw jsonDecode(response.body) ?? "Unknown error ocured";
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

  Future userChats(String uid) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.userChat + uid);

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<Chat> chatList = chatFromJson(response.body);

        return chatList;
      } else {
        throw jsonDecode(response.body) ?? "Unknown error ocured";
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
}

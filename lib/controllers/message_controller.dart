// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialife_mobile/models/message_model.dart';
import 'package:socialife_mobile/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class MessageController extends GetxController {
  TextEditingController addMessageController = TextEditingController();

  Future getMessages(String chatId) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(ApiEndpoints.baseUrl +
          ApiEndpoints.authEndPoints.getMessages +
          chatId);

      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<Message> messageList = messageFromJson(response.body);

        return messageList;
      } else {
        throw jsonDecode(response.body)['message'] ?? "Unknown error ocured";
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

  Future<void> addMessage(String chatId, senderId) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.addMessage);
      Map body = {
        'chatId': chatId,
        'senderId': senderId,
        'text': addMessageController.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        addMessageController.clear();
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
}

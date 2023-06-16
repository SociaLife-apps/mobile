import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialife_mobile/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socialife_mobile/screens/addFriends.dart';

class UserAction extends GetxController {
  TextEditingController friendController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> add_friend() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('_id');
      var url =
      Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.addFriend);
      Map<String, dynamic> body = {
        'username': friendController.text,
      };
      if (id != null) {
        body['id'] = id;
      }
      http.Response response = await http.put(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        friendController.clear();
    } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occured";
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
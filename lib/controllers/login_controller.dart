// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:socialife_mobile/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
          Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.login);
      Map body = {
        'username': usernameController.text,
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {

        final json = jsonDecode(response.body);

        var user = json['user'];

        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('username', user['username']);
        await prefs?.setString('_id', user['_id']);

        usernameController.clear();
        passwordController.clear();

        Get.off(HomeScreen());
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

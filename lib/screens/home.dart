// ignore_for_file: prefer_const_constructors, unnecessary_nullable_for_final_variable_declarations, unused_import, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/chat_controller.dart';
import 'package:socialife_mobile/controllers/user_controller.dart';

import '../models/chat_model.dart';
import '../models/user_model.dart';
import 'auth/auth_screen.dart';
import 'chat.dart';
import 'addFriends.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChatController chatController = Get.put(ChatController());
  UserController userController = Get.put(UserController());
  List<Map<String, String>> contactList = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    fetchChatContacts();
  }

  Future<void> fetchChatContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? uid = prefs.getString('_id');
    List<Chat> chats = await chatController.userChats(uid!);

    for (Chat chat in chats) {
      String id = chat.id;
      List<String> members = chat.members;

      // Process the members as needed
      String? friends =
          members.firstWhere((member) => member != uid, orElse: () => '');

      String username = await userController.getUser(friends);

      setState(() {
        // Create a map of id and friends
        Map<String, String> contactMap = {
          'id': id,
          'friends': username,
        };

        // Add the map to the contactList
        contactList.add(contactMap);
      });
    }
  }

  void _navigateToAddFriends() {
    Get.to(AddFriendsScreen());
  }

  void _logout() async {
    final SharedPreferences? prefs = await _prefs;
    prefs?.clear();
    Get.offAll(AuthScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SociaLife'),
        leading: IconButton(
          icon: Icon(Icons.person_add),
          onPressed: _navigateToAddFriends,
        ),
      ),
      body: ListView.separated(
        itemCount: contactList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          height: 1.0,
        ),
        itemBuilder: (context, index) {
          final chat = contactList[index];
          final id = chat['id'];
          final friends = chat['friends'];
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
            title: Text(
              friends!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Get.to(ChatScreen(), arguments: [id, friends]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: Icon(Icons.logout),
      ),
    );
  }
}

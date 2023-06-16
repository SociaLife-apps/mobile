// ignore_for_file: prefer_const_constructors, unnecessary_nullable_for_final_variable_declarations, unused_import, unused_local_variable

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/chat_controller.dart';
import 'package:socialife_mobile/controllers/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Timer? _timer;
  int _durationInSeconds = 15; // Timer duration in seconds

  @override
  void initState() {
    super.initState();
    fetchChatContacts();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  void startTimer() {
    _timer = Timer(Duration(seconds: _durationInSeconds), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Take a Break'),
          content: Text(
              'It seems like you\'ve been enjoying our app for 15 minutes straight! We encourage you to take a moment to rest and recharge. Remember, a healthy balance is key to a productive and enjoyable experience. Feel free to resume your activities once you\'re ready. Thank you for using our app!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> fetchChatContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('_id');
    List<Chat> chats = await chatController.userChats(uid!);

    for (Chat chat in chats) {
      String id = chat.id;
      List<String> members = chat.members;
      String? friends =
          members.firstWhere((member) => member != uid, orElse: () => '');
      String username = await userController.getUser(friends);

      DateTime lastContactTime = await getLastContactTimeForFriend(
          id); // Update this line to use the modified method

      setState(() {
        Map<String, String> contactMap = {
          'id': id,
          'friends': username,
        };

        if (lastContactTime != null && isContactOverdue(lastContactTime)) {
          contactMap['overdue'] = 'true';
        } else {
          contactMap['overdue'] = 'false';
        }

        contactList.add(contactMap);
      });
    }
  }

  Future<DateTime> getLastContactTimeForFriend(String friendId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lastContactKey = 'last_contact_$friendId';

    final String? lastContactTimeString = prefs.getString(lastContactKey);

    if (lastContactTimeString != null) {
      final DateTime lastContactTime = DateTime.parse(lastContactTimeString);
      return lastContactTime;
    }

    // Return a default value if no last contact time is stored
    return DateTime(2000); // Change this default value to suit your needs
  }

  bool isContactOverdue(DateTime lastContactTime) {
    final Duration contactThreshold = Duration(
        days: 7); // Define the threshold for considering a contact overdue
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastContactTime);
    return difference >= contactThreshold;
  }

  void _navigateToAddFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('_id');

    Get.to(AddFriendsScreen(), arguments: uid);
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
          final isOverdue = chat['overdue'] ==
              true; // Add this line to check if the contact is overdue

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
            // Add the warning widget if the contact is overdue
            trailing: isOverdue ? Icon(Icons.warning, color: Colors.red) : null,
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

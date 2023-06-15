// ignore_for_file: prefer_const_constructors, unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/chat_controller.dart';
import 'package:socialife_mobile/controllers/message_controller.dart';
// import 'package:socialife_mobile/controllers/user_controller.dart';

import 'auth/auth_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MessageController messageController = Get.put(MessageController());

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> messagesList = [];
  String friends = '';
  var data = Get.arguments;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    
    List<String>? messages = await messageController.getMessages(data[0]) as List<String>;

    setState(() {
      messagesList = messages;
    });
  }

  Future<void> sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? senderId = prefs.getString('_id');
    
    await messageController.addMessage(data[0], senderId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data[1]),
      ),
      body: ListView.separated(
        itemCount: messagesList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          height: 1.0,
        ),
        itemBuilder: (context, index) {
          final chat = messagesList[index];
          return ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
            title: Text('nama teman'),
            subtitle: Text(chat),
            onTap: () {
              // Navigate to chat page
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController.addMessageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                String message = messageController.addMessageController.text;
                sendMessage(message);
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, unused_field, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/chat_controller.dart';
import 'package:socialife_mobile/controllers/message_controller.dart';
import 'package:socialife_mobile/models/message_model.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:socialife_mobile/controllers/user_controller.dart';

import 'auth/auth_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  MessageController messageController = Get.put(MessageController());
  List<Map<String, String>> messageList = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var data = Get.arguments;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Message> messages = await messageController.getMessages(data[0]);

    for (Message message in messages) {
      String text = message.text;
      DateTime createdAt = message.createdAt;
      String relativeTime = timeago.format(createdAt);

      Map<String, String> messageMap = {
        'text': text,
        'createdAt': relativeTime,
        'isCurrentUser':
            message.senderId == prefs.getString('_id') ? 'true' : 'false',
      };

      setState(() {
        messageList.add(messageMap);
      });
    }
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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              reverse: false,
              itemCount: messageList.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                height: 1.0,
              ),
              itemBuilder: (context, index) {
                final message = messageList[index];
                final text = message['text'];
                final created = message['createdAt'];
                final isCurrentUser = message['isCurrentUser'] == 'true';

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text!,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          created!,
                          style: TextStyle(
                            color:
                                isCurrentUser ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController.addMessageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    String message =
                        messageController.addMessageController.text;
                    if (message.isNotEmpty) {
                      sendMessage(message);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


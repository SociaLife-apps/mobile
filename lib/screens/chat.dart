// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifications;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialife_mobile/controllers/message_controller.dart';
import 'package:socialife_mobile/models/message_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  MessageController messageController = Get.put(MessageController());
  List<Map<String, String>> messageList = [];
  IO.Socket? socket;

  notifications.FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      notifications.FlutterLocalNotificationsPlugin();

  var data = Get.arguments;

  Future<void> initializeNotifications() async {
    const notifications.AndroidInitializationSettings
        initializationSettingsAndroid =
        notifications.AndroidInitializationSettings('app_icon');
    final notifications.InitializationSettings initializationSettings =
        notifications.InitializationSettings(
            android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initializeTimeZones() async {
    tz_data.initializeTimeZones();
    final String timeZone = tz.local.name;
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> scheduleNotification() async {
    const notifications.AndroidNotificationDetails
        androidPlatformChannelSpecifics =
        notifications.AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: notifications.Importance.max,
      priority: notifications.Priority.high,
      ticker: 'ticker',
    );

    const notifications.NotificationDetails platformChannelSpecifics =
        notifications.NotificationDetails(
            android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'Hey, It\'s been a while since you last reached out to one of your friends. Why not take a moment today to reconnect and catch up? A simple message can make a big difference in nurturing your friendship. Don\'t let more time slip away—reach out and show them you care.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          notifications.UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void initState() {
    super.initState();
    connectToSocketServer();
    fetchMessages();
    initializeTimeZones();
    initializeNotifications();
  }

  Future<void> connectToSocketServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? senderId = prefs.getString('_id');

    socket = IO.io('ws://10.0.2.2:8800', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      print('Socket connected');
      socket!.emit('new-user-add', senderId);
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket!.on('receive-message', (newMessage) {
      Map<String, dynamic> messageData = Map<String, dynamic>.from(newMessage);

      Map<String, String> messageMap = {
        'text': messageData['text'] as String,
        'createdAt': timeago.format(DateTime.now()),
        'isCurrentUser': messageData['senderId'] == prefs.getString('_id')
            ? 'true'
            : 'false',
      };

      setState(() {
        messageList.add(messageMap);
      });
    });
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Message> messages = await messageController.getMessages(data[0]);

    if (messages.isNotEmpty) {
      Message lastMessage = messages.last;
      DateTime lastMessageTime = lastMessage.createdAt;
      DateTime now = DateTime.now();
      Duration difference = now.difference(lastMessageTime);

      if (difference.inSeconds > 15) {
        await scheduleNotification();
      }
    }

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

    String receiverId = data[2];
    String chatId = data[0];

    Map socketMessage = {
      'senderId': senderId,
      'text': message,
      'chatId': chatId,
      'receiverId': receiverId,
    };
    socket!.emit('send-message', socketMessage);

    // Store the current time as the last contact time for the friend
    final String lastContactKey = 'last_contact_${data[0]}';
    prefs.setString(lastContactKey, DateTime.now().toIso8601String());

    Map<String, String> newMessage = {
      'text': message,
      'createdAt': timeago.format(DateTime.now()),
      'isCurrentUser': 'true',
    };

    setState(() {
      messageList.add(newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the latest message
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(data[1]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _scrollController, // Attach the ScrollController
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

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialife_mobile/controllers/user_controller.dart';
import 'package:socialife_mobile/screens/auth/widgets/input_fields.dart';

class AddFriendsScreen extends StatefulWidget{
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}
class _AddFriendsScreenState extends State<AddFriendsScreen> {
  UserController userController = Get.put(UserController());

  var data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: friendWidget()
      ),
    );
  }


  Widget friendWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a Friend',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        InputTextFieldWidget(
          userController.friendController,
          'Friend\'s Name',
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            userController.addFriend(data);
          },
          child: Text('Search'),
        ),
      ],
    );
}

}




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialife_mobile/controllers/user_action.dart';
import 'package:socialife_mobile/screens/auth/widgets/input_fields.dart';

class AddFriendsScreen extends StatefulWidget{
  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}
class _AddFriendsScreenState extends State<AddFriendsScreen> {
  UserAction userAction = Get.put(UserAction());

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
          userAction.friendController,
          'Friend\'s Name',
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            userAction.add_friend();
          },
          child: Text('Search'),
        ),
      ],
    );
}

}




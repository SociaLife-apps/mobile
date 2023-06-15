// ignore_for_file: prefer_const_declarations, library_private_types_in_public_api

class ApiEndpoints {
  static final String baseUrl = 'http://10.0.2.2:5000/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String register = 'auth/register';
  final String login = 'auth/login';

  final String getUser = 'user/';
  final String updateUser = 'user/:';
  final String addFriend = 'user/';

  final String createChat = 'chat/';
  final String userChat = 'chat/';
  final String findChat = 'chat/';

  final String getMessages = 'message/';
  final String addMessage = 'message/';
}
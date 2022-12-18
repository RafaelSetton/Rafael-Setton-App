import 'package:flutter/material.dart';
import 'package:sql_treino/services/firebase/usersDB.dart';
import 'package:sql_treino/shared/models/messageModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';

class MessageRenderer {
  final UserModel user;
  Map<String, UserModel> _cacheUsers = {};

  MessageRenderer(this.user);

  Widget build(BuildContext context, MessageModel message) {
    if (message.senderEmail == user.email) return _sent(context, message);
    return _received(context, message);
  }

  Widget _sent(BuildContext context, MessageModel message) {
    return Row(
      children: [
        Expanded(child: Container()),
        messageContainer(
          message,
          color: Colors.lightGreen,
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }

  Widget _received(BuildContext context, MessageModel message) {
    return FutureBuilder(
      builder: (_, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return _buildReceived(context, message, snapshot.data!);
        return Container();
      },
      future: _loadUser(message.senderEmail),
    );
  }

  Widget _buildReceived(
      BuildContext context, MessageModel message, UserModel user) {
    return Row(
      children: [
        messageContainer(
          message,
          color: Colors.grey.shade300,
          alignment: CrossAxisAlignment.start,
          header: Text(
            message.senderEmail,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  String formatTime(DateTime time) {
    int h = time.hour;
    int m = time.minute;
    int d = time.day;
    int M = time.month;
    int a = time.year;
    return "$h:$m - $d/$M/$a";
  }

  Widget messageContainer(MessageModel message,
      {Color? color, required CrossAxisAlignment alignment, Widget? header}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          header ?? Container(width: 0, height: 0),
          Wrap(
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            formatTime(message.time),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Future<UserModel> _loadUser(String email) async {
    if (_cacheUsers.containsKey(email)) return _cacheUsers[email]!;
    UserModel temp = (await UserDB.show(email))!;
    _cacheUsers[email] = temp;
    return temp;
  }
}

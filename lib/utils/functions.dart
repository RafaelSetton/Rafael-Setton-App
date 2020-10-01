import 'package:flutter/material.dart';

void route(BuildContext context, String route) {
  Navigator.pop(context);
  Navigator.pushNamed(context, Navigator.defaultRouteName);
  Navigator.pushNamed(context, route);
}

Future<void> alert(BuildContext context, String title, String text,
    {List<Widget> actions, bool okButton: true}) async {
  actions = actions == null ? [] : actions;
  if (okButton) {
    actions.add(FlatButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: actions,
      );
    },
  );
}

Widget backToUserPageLeading(BuildContext context,
    {IconData icon: Icons.arrow_back}) {
  return IconButton(
    icon: Icon(icon),
    onPressed: () => route(context, "/userpage"),
  );
}

class Scheme {
  Color backGround = Colors.grey[100];
  Color primary = Colors.blue[400];
  Color textOnPrimary = Colors.grey[300];
}

class Cryptography {
  static String encrypt(String from) {
    String _new = '';
    for (int i = 0; i < from.length; i++) {
      _new +=
          asciiChars[(asciiChars.indexOf(from[i]) + 10) % asciiChars.length];
    }
    return _new;
  }

  static String decrypt(String from) {
    String _new = '';
    for (int i = 0; i < from.length; i++) {
      _new +=
          asciiChars[(asciiChars.indexOf(from[i]) - 10) % asciiChars.length];
    }
    return _new;
  }
}

Scheme colorTheme = Scheme();
String asciiChars =
    r"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%&()";

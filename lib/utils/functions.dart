import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sql_treino/utils/storage.dart';

void route(BuildContext context, String route) {
  Navigator.popAndPushNamed(context, route);
}

WillPopScope popScope(BuildContext context, Widget child,
    [String target = "/userpage"]) {
  return WillPopScope(
    onWillPop: () async {
      Timer(Duration(milliseconds: 100), () {
        route(context, target);
      });
      return false;
    },
    child: child,
  );
}

Future<String> getUserEmail() async {
  RAM ram = await RAM().load();
  return (await ram.readData())['logged'];
}

Future<void> alert(BuildContext context, String title, String text,
    {List<Widget> actions, bool okButton: true}) async {
  actions = actions == null ? [] : actions;
  if (okButton) {
    actions.add(TextButton(
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

Widget backToPageLeading(BuildContext context,
    {IconData icon: Icons.arrow_back, String target: "/userpage"}) {
  return IconButton(
    icon: Icon(icon),
    onPressed: () => route(context, target),
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
    int displace = Random().nextInt(70);
    for (int i = 0; i < from.length; i++) {
      _new += asciiChars[
          (asciiChars.indexOf(from[i]) + displace) % asciiChars.length];
    }
    return displace.toStringAsPrecision(2) + _new;
  }

  static String decrypt(String from) {
    String _new = '';
    int displace = int.parse(from.substring(0, 2));
    for (int i = 2; i < from.length; i++) {
      _new += asciiChars[
          (asciiChars.indexOf(from[i]) - displace) % asciiChars.length];
    }
    return _new;
  }
}

Scheme colorTheme = Scheme();
String asciiChars =
    r"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%&()";

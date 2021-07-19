import 'package:flutter/material.dart';

const List<Widget> _emptyList = [];

Future<void> alert(BuildContext context, String title, String text,
    {List<Widget> actions = _emptyList, bool okButton: true}) async {
  if (okButton) {
    actions.add(TextButton(
      child: Text('OK'),
      onPressed: () {
        Navigator.pop(context);
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

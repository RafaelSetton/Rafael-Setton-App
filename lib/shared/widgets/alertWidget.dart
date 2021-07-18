import 'package:flutter/material.dart';

Future<void> alert(BuildContext context, String title, String text,
    {List<Widget> actions, bool okButton: true}) async {
  actions = actions == null ? [] : actions;
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

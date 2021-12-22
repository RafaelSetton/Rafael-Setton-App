import 'package:flutter/material.dart';

class ProgressDialog<T> {
  Future<T> awaitFuture(BuildContext context, Future<T> future) async {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => alert,
    );
    T result = await future;
    Navigator.pop(context);
    return result;
  }
}

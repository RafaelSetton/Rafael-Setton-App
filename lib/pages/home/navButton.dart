import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text, routeName;

  const NavButton({Key? key, required this.text, required this.routeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        child: Text(
          text,
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName"),
      ),
    );
  }
}

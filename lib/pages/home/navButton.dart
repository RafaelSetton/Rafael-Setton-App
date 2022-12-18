import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text, routeName;

  const NavButton({
    Key? key,
    required this.text,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      height: 75,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/NavButton/$text.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: TextButton(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            backgroundColor: Colors.white70,
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName"),
      ),
    );
  }
}

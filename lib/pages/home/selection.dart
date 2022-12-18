import 'package:flutter/material.dart';
import 'package:sql_treino/pages/home/navButton.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

abstract class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  List<NavButton> get buttons;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
          Text(
            "Você está logado como\n"
            "'${globals.userEmail}'",
            style: TextStyle(
              fontSize: 20,
              height: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ] +
        buttons;

    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

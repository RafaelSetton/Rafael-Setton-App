import 'package:flutter/material.dart';
import 'package:sql_treino/pages/home/navButton.dart';

abstract class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  List<NavButton> get buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: buttons,
        ),
      ),
    );
  }
}

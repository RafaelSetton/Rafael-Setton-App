import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Carregando Dados...",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

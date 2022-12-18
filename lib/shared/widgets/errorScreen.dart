import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Erro ao Carregar Dados :(",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'package:flutter/material.dart';

Widget errorScreen(BuildContext context) => Center(
      child: Text(
        "Erro ao Carregar Dados :(",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );

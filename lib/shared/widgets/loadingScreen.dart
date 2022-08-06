import 'package:flutter/material.dart';

Widget loadingScreen(BuildContext context) => Center(
      child: Text(
        "Carregando Dados...",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );

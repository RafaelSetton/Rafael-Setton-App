import 'package:flutter/material.dart';

Widget loadingScreen() => Center(
      child: Text(
        "Carregando Dados...",
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );

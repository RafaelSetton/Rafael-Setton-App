import 'package:flutter/material.dart';

Widget errorScreen() => Center(
      child: Text(
        "Erro ao Carregar Dados :(",
        style: TextStyle(
          color: Colors.amber,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );

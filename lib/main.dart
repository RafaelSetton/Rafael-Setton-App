import 'package:flutter/material.dart';

import 'package:sql_treino/pages/register.dart';
import 'package:sql_treino/pages/login.dart';
import 'package:sql_treino/pages/userPage.dart';

import 'package:sql_treino/pages/calculator.dart' as calculator;
import 'package:sql_treino/pages/calculoDeIMC.dart' as calculodeIMC;
import 'package:sql_treino/pages/colorGame.dart' as colorGame;
import 'package:sql_treino/pages/conversorDeMoedas.dart' as conversorDeMoedas;
import 'package:sql_treino/pages/todoList.dart' as todoList;

import 'package:sql_treino/utils/functions.dart';

void main() => runApp(MaterialApp(
      color: colorTheme.primary,
      home: Login(),
      routes: <String, WidgetBuilder>{
        "/register": (context) => Register(),
        "/userpage": (context) => UserPage(),
        "/calculator": (context) => calculator.Home(),
        "/calculodeimc": (context) => calculodeIMC.Home(),
        "/colorgame": (context) => colorGame.Home(),
        "/conversordemoedas": (context) => conversorDeMoedas.Home(),
        "/todolist": (context) => todoList.Home(),
      },
    ));

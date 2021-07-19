import 'package:flutter/material.dart';

import 'package:sql_treino/pages/register/index.dart';
import 'package:sql_treino/pages/login/index.dart';
import 'package:sql_treino/pages/home/index.dart';
import 'package:sql_treino/pages/calculadora/index.dart';
import 'package:sql_treino/pages/IMC/index.dart';
import 'package:sql_treino/pages/colorGame/index.dart';
import 'package:sql_treino/pages/conversor/index.dart';
import 'package:sql_treino/pages/splash/index.dart';
import 'package:sql_treino/pages/toDo/index.dart';
import 'package:sql_treino/pages/workoutTimer/index.dart' as WorkoutTimer;

Object? _getArguments(BuildContext context) =>
    ModalRoute.of(context)!.settings.arguments;

final Map<String, WidgetBuilder> routes = {
  "/splash": (context) => SplashPage(),
  "/login": (context) => LoginPage(),
  "/register": (context) => RegisterPage(),
  "/userpage": (context) => HomePage(email: _getArguments(context) as String),
  "/calculator": (context) => CalculadoraPage(),
  "/calculodeimc": (context) => IMCPage(),
  "/colorgame": (context) => ColorGamePage(),
  "/conversordemoedas": (context) => ConversorPage(),
  "/todolist": (context) =>
      ToDoPage(userEmail: _getArguments(context) as String),
  "/workouttimer-run": (context) => WorkoutTimer.Run(),
  "/workouttimer-saved": (context) => WorkoutTimer.Saved(),
  "/workouttimer-edit": (context) => WorkoutTimer.Edit(),
};

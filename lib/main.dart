import 'package:flutter/material.dart';

import 'package:sql_treino/pages/register/index.dart';
import 'package:sql_treino/pages/login/index.dart';
import 'package:sql_treino/pages/home/index.dart';
import 'package:sql_treino/pages/calculadora/index.dart';
import 'package:sql_treino/pages/IMC/index.dart';
import 'package:sql_treino/pages/colorGame/index.dart';
import 'package:sql_treino/pages/conversor/index.dart';
import 'package:sql_treino/pages/toDo/index.dart';
import 'package:sql_treino/pages/workoutTimer/index.dart' as WorkoutTimer;

import 'package:sql_treino/shared/themes/theme.dart';

void main() => runApp(MaterialApp(
      color: AppTheme.primary,
      initialRoute: "/login",
      routes: <String, WidgetBuilder>{
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/userpage": (context) => HomePage(),
        "/calculator": (context) => CalculadoraPage(),
        "/calculodeimc": (context) => IMCPage(),
        "/colorgame": (context) => ColorGamePage(),
        "/conversordemoedas": (context) => ConversorPage(),
        "/todolist": (context) => ToDoPage(),
        "/workouttimer-run": (context) => WorkoutTimer.Run(),
        "/workouttimer-saved": (context) => WorkoutTimer.Saved(),
        "/workouttimer-edit": (context) => WorkoutTimer.Edit(),
      },
    ));

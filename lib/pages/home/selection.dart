import 'package:flutter/material.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key}) : super(key: key);

  Widget button(String text, String routeName, BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        child: Text(
          text,
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Você está logado como\n"
              "'${globals.userEmail}'",
              style: TextStyle(
                fontSize: 20,
                height: 2,
              ),
              textAlign: TextAlign.center,
            ),
            button("Calculadora", "calculator", context),
            button("Cálculo de IMC", "calculodeimc", context),
            button("Color Game", "colorgame", context),
            button("Conversor de Moedas", "conversordemoedas", context),
            button("Todo List", "todolist", context),
            button("Workout Timer", "workouttimer-edit", context),
            button("Chat App", "chatlist", context),
            button("Somando Saber App", "somando-saber", context),
          ],
        ),
      ),
    );
  }
}

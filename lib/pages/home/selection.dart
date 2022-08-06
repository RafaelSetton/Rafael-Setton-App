import 'package:flutter/material.dart';
import 'package:sql_treino/shared/functions/getArguments.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key}) : super(key: key);

  Widget button(String text, String routeName, BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary),
        ),
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName",
            arguments: getArguments(context)),
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
              "'${getArguments(context)!.userEmail}'",
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
          ],
        ),
      ),
    );
  }
}

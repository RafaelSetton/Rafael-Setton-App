import 'package:flutter/material.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/functions/getArguments.dart';
import 'package:sql_treino/shared/themes/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget bodyWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Você está logado como\n'${getArguments(context)!.userEmail}'",
              style: TextStyle(
                fontSize: 20,
                height: 2,
              ),
              textAlign: TextAlign.center,
            ),
            button("Calculadora", "calculator"),
            button("Cálculo de IMC", "calculodeimc"),
            button("Color Game", "colorgame"),
            button("Conversor de Moedas", "conversordemoedas"),
            button("Todo List", "todolist"),
            button("Workout Timer", "workouttimer-edit"),
            button("Chat App", "chatlist"),
          ],
        ),
      ),
    );
  }

  void logout() async {
    await RAM.write("user", null);
    Navigator.pushReplacementNamed(context, "/login");
  }

  Widget button(String text, String routeName) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.primary),
        ),
        child: Text(
          text,
          style: TextStyle(color: AppTheme.textOnPrimary),
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName",
            arguments: getArguments(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Página do Usuário"),
          centerTitle: true,
          leading: TextButton(
              onPressed: logout,
              child: Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.red[400],
                ),
              )),
        ),
        body: bodyWidget(),
      ),
    );
  }
}

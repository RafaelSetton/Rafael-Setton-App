import 'package:flutter/material.dart';
import 'package:sql_treino/services/local/RAM.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

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
              "Você está logado como\n'${widget.email}'",
              style: TextStyle(
                fontSize: 20,
                height: 2,
              ),
              textAlign: TextAlign.center,
            ),
            button("Calculadora", Colors.green, Colors.lightBlue.shade100,
                "calculator"),
            button("Cálculo de IMC", Colors.grey.shade50, Colors.green,
                "calculodeimc"),
            button("Color Game", Colors.purple, Colors.grey, "colorgame"),
            button("Conversor de Moedas", Colors.black, Colors.amberAccent,
                "conversordemoedas"),
            button("Todo List", Colors.grey.shade50, Colors.blue, "todolist"),
            button("Workout Timer", Colors.purple.shade50, Colors.red,
                "workouttimer-edit"),
          ],
        ),
      ),
    );
  }

  void logout() async {
    await RAM.write("user", null);
    Navigator.pushReplacementNamed(context, "/login");
  }

  Widget button(
      String text, Color textColor, Color background, String routeName) {
    return Container(
      width: 200,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(background),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: () => Navigator.pushNamed(context, "/$routeName",
            arguments: widget.email),
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

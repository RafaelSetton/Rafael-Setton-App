import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sql_treino/services/cryptography.dart';
import 'package:sql_treino/services/storage.dart';
import 'package:sql_treino/services/RAM.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/widgets/alertWidget.dart';
import 'package:sql_treino/shared/widgets/input.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future tryLogin() async {
    UserModel? user = await UserDB.show(_email.text);

    if (user == null) {
      // 404 Not Found
      alert(
        context,
        "Usuário não encontrado",
        "O e-mail não está cadastrado. Verifique-o ou efetue o cadastro.",
      );
      _password.text = "";
    } else {
      if (_password.text == Cryptography.decrypt(user.password)) {
        // 200 OK

        await RAM.write("user", _email.text);
        await globals.loadVars();
        Navigator.pushReplacementNamed(context, "/userpage");
      } else {
        // 400 Bad Request
        alert(
          context,
          "Senha Incorreta",
          "Verifique sua senha e tente novamente.",
        );
        _password.text = "";
      }
    }
  }

  Widget loginButton() {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await tryLogin();
          }
          //_formKey = GlobalKey<FormState>();
        },
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
        ),
      ),
    );
  }

  Widget goToRegisterButton() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, "/register"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Não possuo registro.",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          Icon(Icons.person_add, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Input(
                    controller: _email,
                    label: "E-mail",
                    hint: "seunome@exemplo.com"),
                Input(
                    controller: _password,
                    label: "Senha",
                    hint: "********",
                    hide: true),
                loginButton(),
                goToRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

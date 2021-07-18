import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/services.dart';
import 'package:sql_treino/services/cryptography/cryptography.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/widgets/alertWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (Foundation.kDebugMode) {
      // Database Updates, etc.
    }

    Timer(Duration(milliseconds: 10), () async {
      RAM ram = await RAM().load();
      Map data = await ram.readData();
      if (data['logged'] != null) {
        Navigator.pushReplacementNamed(context, "/userpage");
      }
    });
  }

  Widget input(TextEditingController controller, String label, String hint,
      {bool hide = false}) {
    InputDecoration decoration = InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.blue[900],
        fontSize: 15,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blueGrey,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        obscureText: hide,
        decoration: decoration,
        style: TextStyle(
          color: Colors.blue[500],
          fontSize: 18,
        ),
        cursorWidth: 1.5,
        cursorColor: Color.fromRGBO(40, 40, 230, 1),
        validator: (value) {
          return value.isEmpty
              ? "O campo \"$label\" deve ser preenchido."
              : null;
        },
      ),
    );
  }

  Future tryLogin() async {
    Map user = await UserDB().show(_email.text);

    if (user == null) {
      // 404 Not Found
      alert(
        context,
        "Usuário não encontrado",
        "O e-mail não está cadastrado. Verifique-o ou efetue o cadastro.",
      );
      _password.text = "";
    } else {
      if (_password.text == Cryptography.decrypt(user['password'])) {
        // 200 OK
        RAM ram = await RAM().load();
        ram.editData("logged", _email.text);
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
          if (_formKey.currentState.validate()) {
            await tryLogin();
          }
          //_formKey = GlobalKey<FormState>();
        },
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
        ),
      ),
    );
  }

  Widget register() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, "/register"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Não possuo registro.",
            style: TextStyle(
              color: Colors.lightBlue[400],
              decoration: TextDecoration.underline,
            ),
          ),
          Icon(Icons.person_add, color: Colors.lightBlue[400]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () async {
            RAM ram = await RAM().load();
            if ((await ram.readData())['logged'] != null) {
              Navigator.pushReplacementNamed(context, "/userpage");
            }
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                input(_email, "E-mail", "seunome@exemplo.com"),
                input(_password, "Senha", "", hide: true),
                loginButton(),
                register(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

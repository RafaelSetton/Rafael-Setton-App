import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/services/cryptography.dart';
import 'package:sql_treino/services/storage.dart';
import 'package:sql_treino/shared/models/userDataModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/widgets/alertWidget.dart';
import 'package:sql_treino/shared/widgets/commonInput.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _confirm = TextEditingController();
  DateTime _birthday = DateTime.now().subtract(Duration(days: 365 * 12 + 3));

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget birthdayInput() {
    return Container(
      height: 200,
      child: CupertinoDatePicker(
        backgroundColor: Theme.of(context).backgroundColor,
        mode: CupertinoDatePickerMode.date,
        initialDateTime: _birthday,
        onDateTimeChanged: (DateTime date) {
          _birthday = date;
        },
        maximumDate: DateTime.now().subtract(Duration(days: 365 * 12 + 3)),
      ),
    );
  }

  void tryRegister() async {
    if (_password.text != _confirm.text) {
      alert(context, "Erro",
          "As senhas que você digitou não coincidem. Altere-as e tente novamente.");
      _password.text = "";
      _confirm.text = "";
      return;
    }
    UserModel user = UserModel(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: Cryptography.encrypt(_password.text),
      birthday: "${_birthday.day}/${_birthday.month}/${_birthday.year}",
      data: UserDataModel(colorGamePts: 0, todos: [], workouts: {}, chats: []),
    );
    String err = await UserDB.post(user, create: true);
    switch (err) {
      case "senha":
        alert(
            context,
            "Senha inválida",
            "A sua senha contém um caractere inválido.\n"
                "Os caracteres válidos são:\n"
                "a-z A-Z 0-9 .()!@#\$%&");
        _password.text = "";
        _confirm.text = "";
        break;
      case "e-mail":
        alert(context, "E-mail inválido",
            "O e-mail que você digitou já está cadastrado.");
        _email.text = "";
        break;
      default:
        alert(context, "Registrado",
            "Parabens ${_name.text}, seu registro foi efetuado com sucesso");
        _name.text = "";
        _email.text = "";
        _password.text = "";
        _confirm.text = "";
        break;
    }
  }

  Widget registerButton() {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            tryRegister();
          }
        },
        child: Text(
          "Register",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                input(
                    controller: _name,
                    label: "Nome Completo",
                    hint: "João da Silva Oliveira"),
                input(
                    controller: _email,
                    label: "E-mail",
                    hint: "seu_nome@exemplo.com"),
                input(
                    controller: _password,
                    label: "Senha",
                    hint: "",
                    hide: true),
                input(
                    controller: _confirm,
                    label: "Confirmar Senha",
                    hint: "",
                    hide: true),
                birthdayInput(),
                registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

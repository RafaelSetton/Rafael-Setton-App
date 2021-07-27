import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/services/cryptography/cryptography.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/shared/functions/emptyValidator.dart';
import 'package:sql_treino/shared/models/userDataModel.dart';
import 'package:sql_treino/shared/models/userModel.dart';
import 'package:sql_treino/shared/themes/theme.dart';
import 'package:sql_treino/shared/widgets/alertWidget.dart';

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
        validator: emptyValidator("O campo \"$label\" deve ser preenchido."),
      ),
    );
  }

  Widget birthdayInput() {
    return Container(
      height: 200,
      child: CupertinoDatePicker(
        backgroundColor: AppTheme.backGround,
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
      data: UserDataModel(colorGamePts: 0, todos: [], workouts: {}),
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
            color: AppTheme.textOnPrimary,
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.primary),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                input(_name, "Nome Completo", "João da Silva Oliveira"),
                input(_email, "E-mail", "seu_nome@exemplo.com"),
                input(_password, "Senha", "", hide: true),
                input(_confirm, "Confirmar Senha", "", hide: true),
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sql_treino/shared/functions/buildFuture.dart';
import 'dart:async';
import 'dart:convert';

class ConversorPage extends StatefulWidget {
  @override
  _ConversorPageState createState() => _ConversorPageState();
}

class _ConversorPageState extends State<ConversorPage> {
  TextEditingController reaisController = TextEditingController();
  TextEditingController dolaresController = TextEditingController();
  TextEditingController eurosController = TextEditingController();

  late double dolar;
  late double euro;

  static const request = "https://economia.awesomeapi.com.br/json/all";

  void _realChange(String text) {
    if (text == "") {
      dolaresController.text = "0,00";
      eurosController.text = "0,00";
    } else {
      double value = double.parse(text);
      dolaresController.text = (value / dolar).toStringAsFixed(2);
      eurosController.text = (value / euro).toStringAsFixed(2);
    }
  }

  void _dolarChange(String text) {
    if (text == "") {
      reaisController.text = "0,00";
      eurosController.text = "0,00";
    } else {
      double value = double.parse(text);
      reaisController.text = (value * dolar).toStringAsFixed(2);
      eurosController.text = (value * dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChange(String text) {
    if (text == "") {
      dolaresController.text = "0,00";
      reaisController.text = "0,00";
    } else {
      double value = double.parse(text);
      dolaresController.text = (value * euro / dolar).toStringAsFixed(2);
      reaisController.text = (value * euro).toStringAsFixed(2);
    }
  }

  Widget bodyBuilder() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 150,
            color: Colors.amber,
          ),
          buildTextField("Reais", "R\$ ", reaisController, _realChange),
          Divider(height: 10),
          buildTextField("Dólares", "US\$ ", dolaresController, _dolarChange),
          Divider(height: 10),
          buildTextField("Euros", "€ ", eurosController, _euroChange),
        ],
      ),
    );
  }

  Future getData() async {
    http.Response response = await http.get(Uri.parse(request));
    Map data = json.decode(response.body);
    dolar = double.parse(data["USD"]["high"]);
    euro = double.parse(data["EUR"]["high"]);
  }

  TextField buildTextField(String label, String prefix,
      TextEditingController controller, void Function(String) onChange) {
    return TextField(
      onChanged: onChange,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: "0,00",
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
          fontSize: 15,
        ),
        prefixText: prefix,
      ),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text("\$ Conversor de Moedas \$"),
          backgroundColor: Colors.amber,
          leading: BackButton(),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: buildFuture(bodyBuilder),
        ),
      ),
    );
  }
}

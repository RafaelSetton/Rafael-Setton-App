import 'package:flutter/material.dart';
import 'package:sql_treino/shared/widgets/commonInput.dart';

class IMCPage extends StatefulWidget {
  @override
  _IMCPageState createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _infoText = "Informe seus Dados";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields() {
    heightController.text = "";
    weightController.text = "";
    setState(() {
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcular() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.6) {
        _infoText = "Abaixo do Peso";
      } else if (imc < 25) {
        _infoText = "Peso Ideal";
      } else if (imc < 30) {
        _infoText = "Levemente Acima do Peso";
      } else if (imc < 35) {
        _infoText = "Obesidade Grau I";
      } else if (imc < 40) {
        _infoText = "Obesidade Grau II";
      } else {
        _infoText = "Obesidade Grau III";
      }
      _infoText += " (${imc.toStringAsPrecision(3)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 150,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              input(
                controller: weightController,
                label: "Peso (kg)",
                hint: "65",
                keyboardType: TextInputType.number,
              ),
              input(
                controller: heightController,
                label: "Altura (cm)",
                hint: "170",
                keyboardType: TextInputType.number,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calcular();
                    }
                  },
                  child: Text(
                    "Calcular",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

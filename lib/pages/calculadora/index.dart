import 'dart:math';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String calculus = "";
  int maxScreenLength = 24;
  double availableHeight = 0;
  String? varA, varB, varC, varD;

  String calculate(String string) {
    string = string
        .replaceAll('π', pi.toString())
        .replaceAll('e', e.toString())
        .replaceAll('÷', '/')
        .replaceAll('X', '*')
        .replaceAll(',', '.');
    try {
      return string.interpret().toString().replaceAll('.', ',');
    } catch (e) {
      return "Syntax Error";
    }
  }

  void click(dynamic n) {
    setState(() {
      String x = n.toString();
      if (calculus.length < maxScreenLength) calculus += x;

      RegExp regex = RegExp("0[^,]+");
      while (regex.matchAsPrefix(calculus) != null) {
        calculus = calculus.substring(1);
      }
    });
  }

  void virgula() {
    String ops = 'πe+-X÷^()';
    for (int i = calculus.length - 1; i >= 0; i--) {
      String c = calculus[i];
      if (ops.contains(c))
        break;
      else if (c == ',') return;
    }
    setState(() {
      calculus += ',';
    });
  }

  void delete() {
    setState(() {
      calculus = calculus.substring(0, calculus.length - 1);
    });
  }

  void clear() {
    setState(() {
      calculus = '';
    });
  }

  void a() {
    setState(() {
      if (calculus != "") {
        varA = calculate(calculus);
      } else if (varA != "") {
        calculus = varA ?? "";
      }
    });
  }

  void b() {
    setState(() {
      if (calculus != "") {
        varB = calculate(calculus);
      } else if (varB != "") {
        calculus = varB ?? "";
      }
    });
  }

  void c() {
    setState(() {
      if (calculus != "") {
        varC = calculate(calculus);
      } else if (varC != "") {
        calculus = varC ?? "";
      }
    });
  }

  void d() {
    setState(() {
      if (calculus != "") {
        varD = calculate(calculus);
      } else if (varD != "") {
        calculus = varD ?? "";
      }
    });
  }

  Container myContainer(String text,
      {double width = 0.25,
      Color bg = Colors.white70,
      void Function()? callback}) {
    if (callback == null) {
      callback = () => click(text);
    }
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: availableHeight / 9,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(),
      ),
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: callback,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bg),
        ),
      ),
    );
  }

  Widget screen() {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      color: Colors.black,
      child: Text(
        calculus,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: TextStyle(
            fontSize: 50, color: Colors.white, fontStyle: FontStyle.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      availableHeight =
          MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: screen()),
          Row(
            children: <Widget>[
              myContainer("CE", bg: Colors.orange, callback: clear),
              myContainer("⌫", bg: Colors.green, callback: delete),
              myContainer("(", bg: Colors.lightBlueAccent),
              myContainer(")", bg: Colors.lightBlueAccent),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("π", bg: Colors.green),
              myContainer("e", bg: Colors.green),
              myContainer("xʸ", bg: Colors.green, callback: () => click("^")),
              myContainer("÷", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("1"),
              myContainer("2"),
              myContainer("3"),
              myContainer("X", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("4"),
              myContainer("5"),
              myContainer("6"),
              myContainer("-", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("7"),
              myContainer("8"),
              myContainer("9"),
              myContainer("+", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("0", width: 0.5),
              myContainer(",", bg: Colors.white54, callback: virgula),
              myContainer("=", bg: Colors.green, callback: () {
                setState(() => calculus = calculate(calculus));
              }),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer("A", bg: Colors.red, callback: a),
              myContainer("B", bg: Colors.red, callback: b),
              myContainer("C", bg: Colors.red, callback: c),
              myContainer("D", bg: Colors.red, callback: d),
            ],
          ),
        ],
      ),
    );
  }
}

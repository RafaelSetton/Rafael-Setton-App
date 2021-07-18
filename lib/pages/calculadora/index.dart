import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String calculus = "";
  int maxScreenLength = 24;
  String varA, varB, varC, varD;

  void click(num) {
    setState(() {
      String x = num.toString();
      if (calculus.length < maxScreenLength) {
        try {
          if ('^X÷+-('.contains(calculus[-2]) && '^X÷+-'.contains(x[1])) {
            calculus = calculus.substring(0, calculus.length - 3) + x;
          } else if (calculus.length > 0 || !('^X÷+-'.contains(x[1]))) {
            calculus += x;
          }
        } catch (err) {
          try {
            if (calculus.length > 0 || !('^X÷+-'.contains(x[1]))) {
              calculus += x;
            }
          } catch (err2) {
            calculus += x;
          }
        }
      }
      while (calculus.startsWith('0') && calculus.length != 1) {
        calculus = calculus.substring(1);
      }
    });
  }

  void virgula() {
    setState(() {
      List<String> lista = calculus.split(' ');
      if (!(lista[lista.length - 1].contains(','))) {
        calculus += ',';
      }
    });
  }

  void delete() {
    setState(() {
      int ult;
      if (calculus[calculus.length - 1] == ' ') {
        ult = 3;
      } else {
        ult = 1;
      }
      calculus = calculus.substring(0, calculus.length - ult);
    });
  }

  void clear() {
    setState(() {
      calculus = '';
    });
  }

  String calc(String string) {
    void syntaxError() {
      setState(() {
        calculus = "Syntax Error";
      });
    }

    bool validacao(List<String> str) {
      try {
        double.parse(str[0]);
      } catch (err) {
        if (!'(eπ'.contains(str[0])) {
          syntaxError();
          return false;
        }
      }

      int cont = 0;
      for (var char in str) {
        if (char == '(') {
          cont++;
        } else if (char == ')') {
          cont--;
        }
        if (cont < 0) {
          syntaxError();
          return false;
        }
      }
      if (cont != 0) {
        syntaxError();
        return false;
      }
      return true;
    }

    List<int> findParenthesis(List<String> str) {
      str.removeWhere((x) => x.length == 0);
      int start = str.indexOf('(') + 1;
      int back, front;
      while (true) {
        back = str.indexOf(')', start);
        front = str.indexOf('(', start);
        if (front < 0 || back < front) {
          return [start, back];
        }
        start = front + 1;
      }
    }

    string = string.replaceAll(',', '.');
    string = string.replaceAll('π', math.pi.toString());
    string = string.replaceAll('e', math.e.toString());
    string = string.replaceAll('  ', ' ');
    if (string.startsWith(' ')) {
      string = string.substring(1);
    }
    if (string.endsWith(' ')) {
      string = string.substring(0, string.length - 1);
    }
    List<String> listString = string.split(' ');
    validacao(listString);

    while (listString.contains('(')) {
      int ini = findParenthesis(listString)[0];
      int fim = findParenthesis(listString)[1];
      List<String> novo = listString.sublist(ini, fim);
      for (var i = 0; i < fim - ini + 2; i++) {
        listString.removeAt(ini - 1);
      }
      String insert = calc(novo.join(" ")).replaceAll(',', '.');
      listString.insert(ini - 1, insert);
    }

    int i = 1;
    while (listString.contains('^') && i < listString.length) {
      if (listString[i] == '^') {
        double f1 = double.parse(listString.removeAt(i - 1));
        listString.removeAt(i - 1);
        double f2 = double.parse(listString.removeAt(i - 1));
        listString.insert(i - 1, math.pow(f1, f2).toString());
        i--;
      }
      i++;
    }

    i = 1;
    while ((listString.contains('X') || listString.contains('÷')) &&
        i < listString.length) {
      if (listString[i] == 'X') {
        double f1 = double.parse(listString.removeAt(i - 1));
        listString.removeAt(i - 1);
        double f2 = double.parse(listString.removeAt(i - 1));
        listString.insert(i - 1, (f1 * f2).toString());
        i--;
      } else if (listString[i] == '÷') {
        double f1 = double.parse(listString.removeAt(i - 1));
        listString.removeAt(i - 1);
        double f2 = double.parse(listString.removeAt(i - 1));
        listString.insert(i - 1, (f1 / f2).toString());
        i--;
      }
      i++;
    }

    i = 1;
    while ((listString.contains('+') || listString.contains('-')) &&
        i < listString.length) {
      if (listString[i] == '+') {
        double f1 = double.parse(listString.removeAt(i - 1));
        listString.removeAt(i - 1);
        double f2 = double.parse(listString.removeAt(i - 1));
        listString.insert(i - 1, (f1 + f2).toString());
        i--;
      } else if (listString[i] == '-') {
        double f1 = double.parse(listString.removeAt(i - 1));
        listString.removeAt(i - 1);
        double f2 = double.parse(listString.removeAt(i - 1));
        listString.insert(i - 1, (f1 - f2).toString());
        i--;
      }
      i++;
    }

    string = listString[0].replaceAll('.', ',');
    return string;
  }

  void a() {
    setState(() {
      if (calculus != "") {
        varA = calc(calculus);
      } else if (varA != "") {
        calculus = varA;
      }
    });
  }

  void b() {
    setState(() {
      if (calculus != "") {
        varB = calc(calculus);
      } else if (varB != "") {
        calculus = varB;
      }
    });
  }

  void c() {
    setState(() {
      if (calculus != "") {
        varC = calc(calculus);
      } else if (varC != "") {
        calculus = varC;
      }
    });
  }

  void d() {
    setState(() {
      if (calculus != "") {
        varD = calc(calculus);
      } else if (varD != "") {
        calculus = varD;
      }
    });
  }

  Container myContainer(
      {String text,
      double width = 0.25,
      Color bg = Colors.white70,
      callback = false}) {
    if (callback == false) {
      callback = () => click(text);
    }
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height / 10,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        centerTitle: true,
        leading: BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 5.75,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            color: Colors.black,
            child: Text(
              calculus,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Row(
            children: <Widget>[
              myContainer(text: "CE", bg: Colors.orange, callback: clear),
              myContainer(text: "⌫", bg: Colors.green, callback: delete),
              myContainer(text: " ( ", bg: Colors.lightBlueAccent),
              myContainer(text: " ) ", bg: Colors.lightBlueAccent),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: " π ", bg: Colors.green),
              myContainer(text: " e ", bg: Colors.green),
              myContainer(
                  text: "xʸ",
                  bg: Colors.green,
                  callback: () {
                    click(" ^ ");
                  }),
              myContainer(text: " ÷ ", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: "1"),
              myContainer(text: "2"),
              myContainer(text: "3"),
              myContainer(text: " X ", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: "4"),
              myContainer(text: "5"),
              myContainer(text: "6"),
              myContainer(text: " - ", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: "7"),
              myContainer(text: "8"),
              myContainer(text: "9"),
              myContainer(text: " + ", bg: Colors.green),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: "0", width: 0.5),
              myContainer(text: ",", bg: Colors.white54, callback: virgula),
              myContainer(
                  text: "=",
                  bg: Colors.green,
                  callback: () {
                    setState(() {
                      calculus = calc(calculus);
                    });
                  }),
            ],
          ),
          Row(
            children: <Widget>[
              myContainer(text: "A", bg: Colors.red, callback: a),
              myContainer(text: "B", bg: Colors.red, callback: b),
              myContainer(text: "C", bg: Colors.red, callback: c),
              myContainer(text: "D", bg: Colors.red, callback: d),
            ],
          ),
        ],
      ),
    );
  }
}

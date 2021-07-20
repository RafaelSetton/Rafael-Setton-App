import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:petitparser/petitparser.dart';

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String calculus = "";
  int maxScreenLength = 24;
  String? varA, varB, varC, varD;

  void click(dynamic n) {
    setState(() {
      String x = n.toString();
      if (calculus.length < maxScreenLength) calculus += x;

      while (calculus.startsWith('0') && calculus.length != 1) {
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

  Parser buildParser() {
    final builder = ExpressionBuilder();
    builder.group()
      ..primitive((pattern('+-').optional() &
              digit().plus() &
              (char(',') & digit().plus()).optional() &
              (pattern('eE') & pattern('+-').optional() & digit().plus())
                  .optional())
          .flatten('number expected')
          .trim()
          .map(num.tryParse))
      ..wrapper(
          char('(').trim(), char(')').trim(), (left, value, right) => value);
    builder.group().prefix(char('-').trim(), (op, num a) => -a);
    builder
        .group()
        .right(char('^').trim(), (num a, op, num b) => math.pow(a, b));
    builder.group()
      ..left(char('X').trim(), (num a, op, num b) => a * b)
      ..left(char('÷').trim(), (num a, op, num b) => a / b);
    builder.group()
      ..left(char('+').trim(), (num a, op, num b) => a + b)
      ..left(char('-').trim(), (num a, op, num b) => a - b);
    return builder.build().end();
  }

  String calc(String string) {
    string = string.replaceAll('π', math.pi.toString());
    string = string.replaceAll('e', math.e.toString());

    final parser = buildParser();
    final result = parser.parse(string);
    if (result.isSuccess)
      return result.value;
    else
      return result.message;
  }

  void a() {
    setState(() {
      if (calculus != "") {
        varA = calc(calculus);
      } else if (varA != "") {
        calculus = varA ?? "";
      }
    });
  }

  void b() {
    setState(() {
      if (calculus != "") {
        varB = calc(calculus);
      } else if (varB != "") {
        calculus = varB ?? "";
      }
    });
  }

  void c() {
    setState(() {
      if (calculus != "") {
        varC = calc(calculus);
      } else if (varC != "") {
        calculus = varC ?? "";
      }
    });
  }

  void d() {
    setState(() {
      if (calculus != "") {
        varD = calc(calculus);
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
    AppBar appBar = AppBar(
      title: Text("Calculadora"),
      centerTitle: true,
      leading: BackButton(),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3 -
                appBar.preferredSize.height,
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
                setState(() => calculus = calc(calculus));
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

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sql_treino/utils/functions.dart';
import 'package:sql_treino/utils/storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> colorStrings = [
    "Vermelho",
    "Laranja",
    "Amarelo",
    "Verde",
    "Azul",
    "Roxo",
    "Branco"
  ];
  List<Color> colorValues = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.white
  ];

  String text = "Pressione Restart";
  Color color = Colors.grey;
  int results = 0;
  double barHeight;
  Timer timer;

  void newText() {
    setState(() {
      text = (colorStrings.toList()
            ..remove(text)
            ..shuffle())
          .first;
      color = (colorValues.toList()
            ..removeAt(colorStrings.indexOf(text))
            ..remove(color)
            ..shuffle())
          .first;
    });
  }

  void click(colorName) {
    if (colorValues.indexOf(colorName) == colorStrings.indexOf(text)) {
      results++;
      barHeight += 20;
    } else {
      barHeight -= 20;
    }
    newText();
  }

  Container colorButton(color) {
    return Container(
        width: MediaQuery.of(context).size.width / 3 - 10,
        height: 100,
        padding: EdgeInsets.all(5),
        color: Colors.black,
        child: RaisedButton(
          onPressed: () {
            click(color);
          },
          color: color,
        ));
  }

  void startTimer(double height) {
    setState(() {
      barHeight = height;
    });
    try {
      timer.cancel();
    } catch (err) {}

    void periodic(time) async {
      if (barHeight >= 1) {
        setState(() {
          barHeight -= 1;
          int micro = results < 150 ? 30000 - results * 100 : 15000;
          timer.cancel();
          timer = Timer.periodic(Duration(microseconds: micro), periodic);
        });
      } else {
        setState(() {
          text = "Pressione Restart";
          color = Colors.grey;
        });
        String email = (await RAM().readData())['logged'];
        Map user = await Database().show(email);
        if (results > user["data"]["colorgamepts"]) {
          user["data"]["colorgamepts"] = results;
          await Database().edit(user);
        }
      }
    }

    timer = Timer.periodic(Duration(microseconds: 30000), periodic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Color Game"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            try {
              timer.cancel();
            } catch (err) {}
            route(context, "/userpage");
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 5),
              alignment: Alignment.bottomCenter,
              height: barHeight,
              width: 30,
              color: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height / 3,
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  //alignment: AlignmentGeometry,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 50,
                        color: color,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              results.toString() + ' pts',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 35),
                            ),
                            width: MediaQuery.of(context).size.width / 3 - 10,
                            color: Colors.black),
                        colorButton(Colors.red),
                        colorButton(Colors.orange),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        colorButton(Colors.purple),
                        colorButton(Colors.white),
                        colorButton(Colors.yellow),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        colorButton(Colors.blue),
                        colorButton(Colors.green),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3 - 10,
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.restore,
                              color: Colors.grey,
                            ),
                            iconSize: 50,
                            onPressed: () {
                              startTimer(MediaQuery.of(context).size.height);
                              newText();
                              setState(() {
                                results = 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sql_treino/services/firebase/scoresDB.dart';
import 'package:sql_treino/shared/models/ScoreModel.dart';
import 'package:sql_treino/shared/widgets/game_clock.dart';
import 'dart:async';

class ColorGamePage extends StatefulWidget {
  @override
  _ColorGamePageState createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
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
  int results = 0, resultsWrong = 0;
  late GameClockCountDownController countDownController;
  int hs = 0;
  bool disabled = true;

  @override
  void initState() {
    super.initState();

    countDownController =
        GameClockCountDownController(60, onChange: () => setState(() {}));

    Future.delayed(Duration(milliseconds: 10), () async {
      List<ScoreModel> scores = await ScoresDB.get("ColorGame");
      setState(() {
        hs = scores.isEmpty
            ? 0
            : scores.reduce((s1, s2) => s1.right > s2.right ? s1 : s2).right;
      });
    });
  }

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

  void click(Color color) {
    if (disabled) return;
    if (colorValues.indexOf(color) == colorStrings.indexOf(text)) {
      results++;
      countDownController.countUp(answerValue);
    } else {
      resultsWrong++;
      countDownController.countDown(answerValue);
    }
    newText();
  }

  Container colorButton(Color color) {
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 100,
        padding: EdgeInsets.all(5),
        color: Colors.black,
        child: ElevatedButton(
          onPressed: () => click(color),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
          child: Container(),
        ));
  }

  Container resetButton() {
    return Container(
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
          disabled = false;
          countDownController.reset();
          countDownController.resume();
          newText();
          setState(() {
            results = 0;
            resultsWrong = 0;
          });
        },
      ),
    );
  }

  void reset() {
    Timer.run(() {
      // Evitar "setState called during build"
      setState(() {
        text = "Pressione Restart";
        color = Colors.grey;
      });
    });
    disabled = true;

    if (countDownController.currentTime == 0) {
      ScoresDB().set(
          "ColorGame",
          ScoreModel(
            dateTime: DateTime.now(),
            right: results,
            wrong: resultsWrong,
          ));
      if (results > hs) hs = results;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Color Game"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SizedBox(width: 15),
                GameClock(
                  onTimerEnd: reset,
                  countDownController: countDownController,
                  backgroundColor: Colors.grey.shade800,
                  startColor: Colors.white,
                  endColor: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - clockSize - 25,
                  height: MediaQuery.of(context).size.height / 3,
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
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
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "High Score: $hs",
                    style: TextStyle(color: Colors.grey, fontSize: 35),
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        results.toString() + ' pts',
                        style: TextStyle(color: Colors.grey, fontSize: 35),
                      ),
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      color: Colors.black,
                    ),
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
                    resetButton(),
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

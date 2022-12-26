import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sql_treino/shared/models/ScoreModel.dart';
import 'package:sql_treino/services/firebase/scoresDB.dart';
import 'package:function_tree/function_tree.dart';
import 'package:sql_treino/shared/widgets/game_clock.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String? mode;
  String typed = "", _equation = "";
  AudioPlayer player = AudioPlayer();
  List<String> operations = [];
  Random generator = Random(DateTime.now().millisecondsSinceEpoch);
  int right = 0, wrong = 0;
  late GameClockCountDownController countDownController;

  @override
  void initState() {
    super.initState();
    countDownController =
        GameClockCountDownController(60, onChange: () => setState(() {}));
    Timer(Duration(microseconds: 10), countDownController.resume);

    mode = globals.arguments as String;
    if (mode!.contains("Adição")) operations.add("+");
    if (mode!.contains("Subtração")) operations.add("-");
    if (mode!.contains("Multiplicação")) operations.add("*");
    if (mode!.contains("Divisão")) operations.add("/");
    newEquation();
  }

  @override
  void dispose() {
    countDownController.dispose();
    super.dispose();
  }

  void newEquation() {
    String op = operations[generator.nextInt(operations.length)];
    int n1, n2;
    switch (op) {
      case "+":
      case "-":
        n1 = generator.nextInt(100);
        n2 = generator.nextInt(100);
        int temp = n1;
        n1 = max(n1, n2);
        n2 = min(n2, temp);
        break;
      case "*":
        n1 = generator.nextInt(16);
        n2 = generator.nextInt(16);
        break;
      case "/":
        n1 = generator.nextInt(16);
        n2 = generator.nextInt(15) + 1; // Avoid division by 0
        n1 *= n2;
        break;
      default:
        n1 = generator.nextInt(100);
        n2 = generator.nextInt(100);
    }
    setState(() {
      _equation = n1.toString() + op + n2.toString();
    });
  }

  Future saveScore() async {
    await ScoresDB().set(
      "SSA",
      ScoreModel(
        dateTime: DateTime.now(),
        mode: mode ?? "",
        right: right,
        wrong: wrong,
      ),
    );
    Navigator.of(context).pop();
  }

  // Buttons

  Widget keyButton(
      {void Function()? onPressed,
      required String text,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 23),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
        ),
      ),
    );
  }

  Widget numButton(BuildContext context, int n) {
    n = n % 10;
    return keyButton(
      onPressed: () {
        setState(() {
          typed += n.toString();
        });
      },
      text: n.toString(),
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget confirm() {
    return keyButton(
      onPressed: () async {
        if (typed.isEmpty) return;

        await player.stop();
        if (_equation.interpret() == typed.interpret()) {
          player.play(AssetSource("../lib/assets/Somando_Saber/right.wav"),
              volume: 100);
          newEquation();
          right++;
        } else {
          player.play(AssetSource("../lib/assets/Somando_Saber/wrong.wav"),
              volume: 100);
          wrong++;
        }
        setState(() {
          typed = "";
        });
      },
      text: "✓",
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  Widget clear() {
    return keyButton(
      onPressed: () async {
        setState(() {
          typed = "";
        });
      },
      text: "CLEAR",
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  // Widgets

  Widget equation() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white38, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        _equation,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
    );
  }

  Widget answer() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white38, width: 3)),
      ),
      child: Text(
        "=  " + typed,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget keyboard() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Somando_Saber/keyboard.jpg"),
            fit: BoxFit.none,
            scale: 8,
            alignment: Alignment.center,
          ),
        ),
        alignment: Alignment.center,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [for (var i = 1; i <= 10; i++) numButton(context, i)]
            ..insert(9, clear())
            ..add(confirm()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mode ?? "Jogar"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        height:
            MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                equation(),
                GameClock(
                  onTimerEnd: saveScore,
                  countDownController: countDownController,
                ),
              ],
            ),
            answer(),
            keyboard(),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sql_treino/pages/workoutTimer/shared.dart';

class Run extends StatefulWidget {
  @override
  _RunState createState() => _RunState();
}

class _RunState extends State<Run> {
  bool isPaused = false;
  bool isSoundPlaying = false;

  FlutterTts textToSpeech = FlutterTts();
  Timer speakControlTimer;
  List spoken = [];
  bool announced = false;
  int ready = 0;

  List<Map<String, int>> sequence = [];
  CountDownController timeController = CountDownController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1), () async {
      await _loadRAM();
      String thisName = sequence[0].keys.first;
      int thisTime = sequence[0][thisName];
      textToSpeech.speak(
          "Vamos começar. Primeiro exercício: $thisName, $thisTime segundos");
      textToSpeech.setCompletionHandler(() {
        setState(() {
          ready++;
        });
        textToSpeech.setCompletionHandler(() {});
      });
    });
  }

  @override
  void dispose() {
    textToSpeech.stop();
    super.dispose();
  }

  // Handle DB connections

  Future _loadRAM() async {
    List workout = await loadRAM(); // List<Map<String, String>
    setState(() {
      sequence = workout
          .map((pair) => <String, int>{pair.keys.first: pair.values.first})
          .toList();
      ready++;
    });
  }

  // Speakers

  void announceNext() {
    try {
      String nextName = sequence[1].keys.first;
      int nextTime = sequence[1][nextName];
      textToSpeech.speak("Próximo exercício: $nextName, $nextTime segundos");
    } on RangeError {
      textToSpeech.speak("Finalizando treino");
    }
  }

  void periodicTimeHandler(Timer timer) {
    int timeLeft = int.parse(timeController.getTime());
    switch (timeLeft) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        if (!spoken.contains(timeLeft)) {
          textToSpeech.speak(timeLeft.toString());
          spoken.add(timeLeft);
        }
        break;
      case 10:
        if (!announced) {
          announced = true;
          announceNext();
        }
        break;
    }
  }

  // Widget Helpers

  Widget circleTimer() {
    return CircularCountDownTimer(
      duration: sequence.first.values.first,
      controller: timeController,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.grey[300],
      fillColor: Colors.blue[300],
      backgroundColor: Colors.blue[900],
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: TextStyle(
          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.SS,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {
        print('Countdown Started');
        textToSpeech.speak(sequence.first.keys.first);

        speakControlTimer =
            Timer.periodic(Duration(milliseconds: 200), periodicTimeHandler);
      },
      onComplete: () {
        print('Countdown Finished');

        setState(() {
          spoken = [];
          announced = false;
          if (sequence.length > 1) {
            sequence.removeAt(0);
            timeController.restart(duration: sequence.first.values.first);
          } else {
            timeController.pause();
            () async {
              await textToSpeech.speak("Treino finalizado");
              textToSpeech.setCompletionHandler(() => Navigator.pop(context));
            }();
          }
        });
      },
    );
  }

  Widget button(IconData icon, Color color, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              fixedSize: MaterialStateProperty.all(Size.fromHeight(100))),
          onPressed: onPressed,
          child: Icon(
            icon,
            color: color,
            size: 75,
          ),
        ),
      ),
    );
  }

  Widget buttonRow() {
    List<Widget> children = isPaused
        ? [
            button(Icons.stop, Colors.red, () {
              Navigator.pop(context);
            }),
            button(Icons.play_arrow, Colors.green, () {
              setState(() {
                isPaused = false;
                timeController.resume();
              });
            }),
          ]
        : [
            button(
              Icons.pause,
              Colors.grey,
              () {
                setState(() {
                  isPaused = true;
                  timeController.pause();
                });
              },
            )
          ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ready == 2
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  sequence.length > 0 ? sequence.first.keys.first : "",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              circleTimer(),
              buttonRow(),
            ],
          )
        : Center();
    return Scaffold(
      appBar: AppBar(
          title: Text("Workout Timer"),
          centerTitle: true,
          leading: BackButton()),
      body: body,
    );
  }
}

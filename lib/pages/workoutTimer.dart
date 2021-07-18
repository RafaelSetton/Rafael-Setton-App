import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

import 'package:sql_treino/utils/functions.dart';
import 'package:sql_treino/utils/storage.dart';

// Saved Screen
class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  List data;
  String _lastRemoved;
  int _lastRemovedPos;

  Future choose(int index) async {
    String name = data[index];
    String userEmail = await getUserEmail();

    List<Map> workout = await WorkoutDB().show(userEmail, name);

    RAM ram = await RAM().load();
    await ram.editData("currentWorkout", workout);

    route(context, "/workouttimer-edit");
  }

  Future<List> getData() async {
    String userEmail = await getUserEmail();
    return await WorkoutDB().list(userEmail);
  }

  Future _saveData() async {
    String userEmail = await getUserEmail();
    List old = await WorkoutDB().list(userEmail);

    old.forEach((element) async {
      if (!data.contains(element)) {
        await WorkoutDB().delete(userEmail, element);
      }
    });
  }

  Widget listItem(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direction) async {
        setState(() {
          _lastRemoved = data[index];
          _lastRemovedPos = index;
          data.removeAt(index);
        });
        await _saveData();
        final snack = SnackBar(
          content: Text("Tarefa \"$_lastRemoved\" excluído!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () async {
              setState(() async {
                data.insert(_lastRemovedPos, _lastRemoved);
                await _saveData();
              });
            },
          ),
          duration: Duration(seconds: 3),
        );
        try {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        } catch (err) {}
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 1,
        ),
        child: TextButton(
          onPressed: () async => await choose(index),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data[index],
                  style: TextStyle(fontSize: 25),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadScreen() {
    return Center(
      child: Text(
        "Carregando Dados...",
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.blueAccent,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget mainBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Timer"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: backToPageLeading(context, target: "/workouttimer-edit"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: this.data.length,
              itemBuilder: listItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget builder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return loadScreen();
      default:
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erro ao Carregar Dados :(",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          this.data = snapshot.data;
          return popScope(
            context,
            mainBody(),
            "/workouttimer-edit",
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.data != null) {
      return builder(
          context, AsyncSnapshot.withData(ConnectionState.done, this.data));
    }
    return popScope(
      context,
      FutureBuilder(
        future: getData(),
        builder: builder,
      ),
    );
  }
}

// Run Screen
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
              textToSpeech.setCompletionHandler(
                  () => route(context, "/workouttimer-edit"));
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
              route(context, "/workouttimer-edit");
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
    return popScope(
      context,
      Scaffold(
        appBar: AppBar(
            title: Text("Workout Timer"),
            centerTitle: true,
            leading: backToPageLeading(context, target: "/workouttimer-edit")),
        body: body,
      ),
      "/workouttimer-edit",
    );
  }
}

// Edit Screen
class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Section _lastRemoved;
  int _lastRemovedPos;

  List<Section> sequence = [];

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () async => await _loadRAM());
  }

  // Handle Item add/delete

  Section createSection(String name, String time) {
    return Section(
      TextEditingController(text: name)
        ..addListener(() async => await _saveRAM()),
      TextEditingController(text: time)
        ..addListener(() async => await _saveRAM()),
      UniqueKey(),
    );
  }

  Future addItem() async {
    String name = nameController.text;
    String time = timeController.text.split(RegExp("[.-]")).first;
    if (name == "" || time == "") {
      return;
    }

    setState(() {
      sequence.add(createSection(name, time));
      nameController.text = "";
      timeController.text = "";
    });
    await _saveRAM();
  }

  Future deleteItem(Key keyOfItem) async {
    setState(() {
      sequence.removeWhere((section) => (section.key == keyOfItem));
    });
    await _saveRAM();
  }

  // Handle DB connections

  Widget dialogBuilder(BuildContext context) {
    TextEditingController saveNameController = TextEditingController();
    return Dialog(
      child: Container(
        height: 150,
        width: 300,
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black87),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: new InputDecoration(
                  hintText: "Treino 01",
                  hintStyle: TextStyle(color: Colors.black26),
                  labelText: "Nome do Treino",
                  labelStyle: TextStyle(color: Colors.blue)),
              controller: saveNameController,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.lightBlue[500]),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text("Salvar"),
              onPressed: () async {
                String userEmail = await getUserEmail();
                await WorkoutDB().post(
                  userEmail,
                  saveNameController.text,
                  sequence.map((e) => e.toList()).toList(),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _saveData() async {
    showDialog(
      context: context,
      builder: dialogBuilder,
    );
  }

  Future _loadRAM() async {
    List workout = await loadRAM();
    setState(() {
      sequence = workout
          .map((pair) =>
              createSection(pair.keys.first, pair.values.first.toString()))
          .toList();
    });
  }

  Future _saveRAM() async {
    RAM ram = await RAM().load();
    await ram.editData(
        "currentWorkout", sequence.map((e) => e.toMap()).toList());
  }

  // Widget Helpers

  Widget inputName(TextEditingController controller) {
    return Container(
      width: 230,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Atividade",
          labelStyle: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget inputTime(TextEditingController controller) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        controller: controller,
        decoration: InputDecoration(
          labelText: "Tempo",
          labelStyle: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, int index) {
    Section section = sequence[index];
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = sequence[index];
          _lastRemovedPos = index;
          sequence.removeAt(index);
        });
        final snack = SnackBar(
          content: Text("Tarefa \"${_lastRemoved.name}\" excluída!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                sequence.insert(_lastRemovedPos, _lastRemoved);
              });
            },
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            inputName(section.name),
            inputTime(section.time),
            Container(
              height: 50,
              width: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                child: Text("-"),
                onPressed: () async => await deleteItem(section.key),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: <Widget>[
        inputName(nameController),
        inputTime(timeController),
        Container(
          height: 50,
          width: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            child: Text("+"),
            onPressed: () async => await addItem(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return popScope(
      context,
      Scaffold(
        appBar: AppBar(
            title: Text("Workout Timer"),
            centerTitle: true,
            leading: backToPageLeading(context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topBar(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: sequence.length,
                itemBuilder: listItem,
              ),
            ),
            Container(
              width: 150,
              height: 40,
              margin: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: Text(
                  "Iniciar",
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  route(context, "/workouttimer-run");
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.transparent,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Text(
                  "Ver Salvos",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  route(context, "/workouttimer-saved");
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.transparent,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Salvar Treino",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _saveData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Section {
  TextEditingController name;
  TextEditingController time;

  Key key;

  Section(this.name, this.time, this.key);

  Map<String, int> toMap() {
    String timeText = time.text != "" ? time.text : "1";

    return <String, int>{name.text: int.parse(timeText)};
  }

  List<String> toList() {
    return <String>[name.text, time.text];
  }

  int getTime() {
    return int.parse(time.text);
  }
}

Future<List> loadRAM() async {
  RAM ram = await RAM().load();
  List workout = (await ram.readData())['currentWorkout'];
  if (workout == null) {
    workout = [];
  }
  return workout != null ? workout : [];
}

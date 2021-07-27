import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sql_treino/pages/workoutTimer/selectionDialog.dart';
import 'package:sql_treino/pages/workoutTimer/shared.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  late Section _lastRemoved;
  late int _lastRemovedPos;

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
                List<WorkoutModel> workouts = sequence
                    .map(
                      (element) => WorkoutModel(
                        title: element.name.text,
                        duration: int.parse(element.time.text),
                      ),
                    )
                    .toList();
                await WorkoutDB.post(saveNameController.text, workouts);

                Navigator.pop(context); // Pop Dialog
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
    List<WorkoutModel> workouts = await loadRAM();
    sequence = workouts
        .map((e) => createSection(e.title, e.duration.toString()))
        .toList();

    setState(() {});
  }

  Future _saveRAM() async {
    List<Map> compiled = sequence
        .map((element) => {
              "title": element.name.text,
              "duration": int.parse(element.time.text),
            })
        .toList();
    await RAM.write("currentWorkout", jsonEncode(compiled));
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
    return Scaffold(
      appBar: AppBar(
          title: Text("Workout Timer"),
          centerTitle: true,
          leading: BackButton()),
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
              onPressed: () async {
                await showDialog(
                    context: context, builder: (_) => SelectionDialog());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.transparent,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              child: Text(
                "Ver Salvos",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await Navigator.pushNamed(context, "/workouttimer-saved");
                await _loadRAM();
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
    );
  }
}

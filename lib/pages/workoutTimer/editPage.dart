import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sql_treino/pages/workoutTimer/savedPage.dart';
import 'package:sql_treino/pages/workoutTimer/selectionDialog.dart';
import 'package:sql_treino/pages/workoutTimer/shared.dart';
import 'package:sql_treino/services/firebase/workoutsDB.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';
import 'package:sql_treino/shared/globals.dart' as globals;

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  List<Section> _sequence = [];
  WorkoutModel get workouts => WorkoutModel(
      workouts: _sequence
          .map(
            (e) => ExerciseModel(
              title: e.name.text,
              duration: int.parse(e.time.text),
            ),
          )
          .toList());
  // Handle Item add/delete

  Section _createSection(String name, String time) {
    return Section(
      TextEditingController(text: name),
      TextEditingController(text: time),
      UniqueKey(),
    );
  }

  Future _addItem() async {
    String name = _nameController.text;
    String time = _timeController.text.split(RegExp("[.-]")).first;
    if (name == "" || time == "") {
      return;
    }

    setState(() {
      _sequence.add(_createSection(name, time));
      _nameController.text = "";
      _timeController.text = "";
    });
  }

  Future _deleteItem(Key keyOfItem) async {
    setState(() {
      _sequence.removeWhere((section) => (section.key == keyOfItem));
    });
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
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: new InputDecoration(
                hintText: "Treino 01",
                labelText: "Nome do Treino",
              ),
              controller: saveNameController,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text("Salvar"),
              onPressed: () async {
                if (saveNameController.text.isEmpty) return;
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
  // Widget Helpers

  Widget inputName(TextEditingController controller) {
    return Container(
      width: 230,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Atividade",
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
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, int index) {
    Section section = _sequence[index];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
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
              onPressed: () async => await _deleteItem(section.key),
            ),
          ),
        ],
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: <Widget>[
        inputName(_nameController),
        inputTime(_timeController),
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
            onPressed: () async => await _addItem(),
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
              itemCount: _sequence.length,
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
                  fontSize: 25,
                ),
              ),
              onPressed: () async {
                globals.arguments = workouts;
                await showDialog(
                  context: context,
                  builder: (_) => SelectionDialog(),
                );
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
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              child: Text(
                "Ver Salvos",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                final WorkoutModel result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Saved()),
                );
                _sequence = result.workouts
                    .map<Section>(
                        (e) => _createSection(e.title, e.duration.toString()))
                    .toList();
                setState(() {});
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
              style: ButtonStyle(
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

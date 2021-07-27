import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/models/workoutModel.dart';

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  late List data;
  late String _lastRemovedName;
  late List<WorkoutModel> _lastRemovedValue;
  late int _lastRemovedPos;

  Future choose(int index) async {
    String name = data[index];
    List<WorkoutModel> workout = await WorkoutDB.show(name);

    await RAM.write(
        "currentWorkout", jsonEncode(workout.map((e) => e.toMap()).toList()));
    Navigator.pop(context);
  }

  Future deleteItem(int index) async {
    _lastRemovedName = data[index];
    _lastRemovedValue = await WorkoutDB.show(_lastRemovedName);
    _lastRemovedPos = index;
    setState(() {
      data.removeAt(index);
    });
    await WorkoutDB.delete(_lastRemovedName);
  }

  Future restoreItem() async {
    setState(() {
      data.insert(_lastRemovedPos, _lastRemovedName);
    });
    await WorkoutDB.post(_lastRemovedName, _lastRemovedValue);
  }

  Widget listItem(BuildContext context, int index) {
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
        await deleteItem(index);

        final snack = SnackBar(
          content: Text("Tarefa \"$_lastRemovedName\" excluído!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: restoreItem,
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
        title: Text("Workout Timer - Treinos Salvos"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: BackButton(),
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
          return mainBody();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WorkoutDB.list(),
      builder: builder,
    );
  }
}

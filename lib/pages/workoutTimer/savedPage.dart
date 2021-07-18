import 'package:flutter/material.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/services/local/RAM.dart';
import 'package:sql_treino/shared/functions.dart';

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

    Navigator.pop(context);
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
    if (this.data != null) {
      return builder(
          context, AsyncSnapshot.withData(ConnectionState.done, this.data));
    }
    return FutureBuilder(
      future: getData(),
      builder: builder,
    );
  }
}

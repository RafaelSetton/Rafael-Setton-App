import 'package:flutter/material.dart';

import 'package:sql_treino/utils/functions.dart';
import 'package:sql_treino/utils/storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  TextEditingController textController = TextEditingController();
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() async {
    List data = await _readData();
    setState(() {
      _toDoList = data;
    });
  }

  Future _saveData() async {
    RAM ram = await RAM().load();
    String email = (await ram.readData())["logged"];
    Map user = await Database().show(email);
    user["data"]["todos"] = _toDoList;
    await Database().post(user);
  }

  Future<List> _readData() async {
    try {
      RAM ram = await RAM().load();
      String email = (await ram.readData())["logged"];
      List todos = (await Database().show(email))['data']["todos"];
      return todos == null ? [] : todos;
    } catch (err) {
      return List();
    }
  }

  void _addToDo() {
    if (textController.text == "") {
      return;
    }
    Map<String, dynamic> newToDo = Map();
    newToDo['title'] = textController.text;
    newToDo['ok'] = false;
    setState(() {
      textController.text = "";
      _toDoList.add(newToDo);
    });
    _saveData();
  }

  Future _sortToDo() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _toDoList.sort((a, b) => a['ok'] ? 1 : -1);
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
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          _saveData();
        });
        final snack = SnackBar(
          content: Text("Tarefa \"${_lastRemoved['title']}\" excluída!"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _toDoList.insert(_lastRemovedPos, _lastRemoved);
                _saveData();
              });
            },
          ),
          duration: Duration(seconds: 3),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
      child: CheckboxListTile(
        onChanged: (value) {
          setState(() {
            _toDoList[index]['ok'] = value;
            _saveData();
          });
        },
        value: _toDoList[index]['ok'],
        title: Text(_toDoList[index]['title']),
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]['ok'] ? Icons.check : Icons.error),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return popScope(
      context,
      Scaffold(
        appBar: AppBar(
          title: Text("Lista de Tarefas"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: backToUserPageLeading(context),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text("ADD"),
                    textColor: Colors.white,
                    onPressed: _addToDo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _toDoList.length,
                  itemBuilder: listItem,
                ),
                onRefresh: _sortToDo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

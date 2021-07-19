import 'package:flutter/material.dart';
import 'package:sql_treino/services/database/storage.dart';
import 'package:sql_treino/shared/models/userModel.dart';

class ToDoPage extends StatefulWidget {
  final String userEmail;

  const ToDoPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List _toDoList = [];
  TextEditingController textController = TextEditingController();
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((value) {
      setState(() {
        _toDoList = value;
      });
    });
  }

  Future _saveData() async {
    UserModel user = (await UserDB.show(widget.userEmail))!;
    user.data["todos"] = _toDoList;
    await UserDB.post(user);
  }

  Future<List> _readData() async {
    try {
      return (await UserDB.show(widget.userEmail))!.data["todos"];
    } catch (err) {
      return [];
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
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: BackButton(),
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text("ADD"),
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
    );
  }
}

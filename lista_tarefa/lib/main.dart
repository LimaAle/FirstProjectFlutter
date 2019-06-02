import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const green = Color(0xff82CC00);
const lightgreen = Color(0xff81A76A);
const darkblue = Color(0xff283B51);
const grenback = Color(0xffEAF5D2);

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(primaryColor: darkblue),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _tasks = [];
  final taskController = TextEditingController();
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readTasks().then((data) {
      setState(() {
        _tasks = json.decode(data);
      });
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _tasks.sort((a, b) {
        if (a['ok'] && !b['ok'])
          return 1;
        else if (!a['ok'] && b['ok'])
          return -1;
        else
          return 0;
      });
      _saveTasks();
    });
    return null;
  }

  void _addTasks() {
    setState(() {
      Map<String, dynamic> newTask = Map();
      newTask['title'] = taskController.text;
      taskController.text = '';
      newTask['ok'] = false;
      _tasks.add(newTask);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas'),
        backgroundColor: green,
        centerTitle: true,
      ),
      backgroundColor: grenback,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: taskController,
                    style: TextStyle(color: darkblue, fontSize: 25),
                    decoration: InputDecoration(
                      labelText: 'nova tarefa',
                      labelStyle: TextStyle(color: darkblue, fontSize: 20),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: darkblue)),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 10),
                  child: RaisedButton(
                  color: darkblue,
                  onPressed: _addTasks,
                  child: Text('Add'),
                  textColor: Colors.white,
                ),
                )
                
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _tasks.length,
                itemBuilder: buildItem,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_tasks[index]);
          _lastRemovedPos = index;
          _tasks.removeAt(index);
          _saveTasks();

          final snack = SnackBar(
            duration: Duration(seconds: 5),
            content: Text('Tarefa: \"${_lastRemoved['title']}\" removida!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _tasks.insert(_lastRemovedPos, _lastRemoved);
                  _saveTasks();
                });
              },
            ),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_tasks[index]['title']),
        value: _tasks[index]['ok'],
        onChanged: (check) {
          setState(() {
            _tasks[index]['ok'] = check;
            _saveTasks();
          });
        },
        secondary: CircleAvatar(
          child: Icon(_tasks[index]['ok'] ? Icons.check : Icons.error),
        ),
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tasks.json');
  }

  Future<File> _saveTasks() async {
    String tasks = json.encode(_tasks);
    final file = await _getFile();
    return file.writeAsString(tasks);
  }

  Future<String> _readTasks() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

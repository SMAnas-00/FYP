import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:newui/Screens/TODO/database.dart';
import 'package:newui/Screens/TODO/dialogbox.dart';

import 'note.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final _myBox = Hive.box('Task');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    super.initState();
  }

  final controller = TextEditingController();

  void checkboxChanged(bool? val, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void savenewtask() {
    setState(() {
      db.toDoList.add([controller.text, false]);
    });
    controller.clear();
  }

  void createnewtask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            Controller: controller,
            onsave: savenewtask,
            oncancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('TODO'),
        backgroundColor: Color(0xFF3A57E8),
        actions: [
          TextButton(
              onPressed: () {
                createnewtask();
              },
              child: Text(
                'Add New',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return Todolist(
            taskname: db.toDoList[index][0],
            taskcompleted: db.toDoList[index][1],
            onChanged: (value) => checkboxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}

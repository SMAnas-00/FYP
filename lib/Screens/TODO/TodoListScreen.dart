// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TodoItem> _todos = [];
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _readData();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _readData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todo_data.txt');
      final contents = await file.readAsString();

      final List<Map<String, dynamic>> todoDataList =
          List<Map<String, dynamic>>.from(
              contents.split('\n').where((line) => line.isNotEmpty).map((line) {
        final parts = line.split(';');
        return {
          'task': parts[0],
          'dateTime': DateTime.parse(parts[1]),
        };
      }));

      setState(() {
        _todos = todoDataList
            .map((data) => TodoItem(data['task'], data['dateTime']))
            .toList();
      });
    } catch (e) {
      print("Error reading data: $e");
    }
  }

  Future<void> _saveData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/todo_data.txt');
    final data = _todos
        .map((todo) => "${todo.task};${todo.dateTime.toIso8601String()}")
        .join('\n');
    await file.writeAsString(data);
  }

  void _addTodo() async {
    if (_formKey.currentState!.validate()) {
      await _selectDateTime(context);
      final task = _taskController.text;
      final dateTime = selectedDateTime;
      final newTodo = TodoItem(task, dateTime);
      setState(() {
        _todos.add(newTodo);
        _taskController.clear();
      });
      _saveData();
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Task'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a task.';
                  }
                  return null;
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.task),
                  subtitle: Text('Date & Time: ${todo.dateTime.toString()}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeTodo(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String task;
  DateTime dateTime;

  TodoItem(this.task, this.dateTime);
}

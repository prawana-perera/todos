import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todos/screens/todo_list.dart';
import 'package:todos/src/database/database.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  _setupServices();
  runApp(TodoApp());
}

void _setupServices() {
  getIt.registerSingleton<TodosDatabase>(TodosDatabase(),
      dispose: (db) => db.close());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(title: 'TODOs App'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );
  }
}

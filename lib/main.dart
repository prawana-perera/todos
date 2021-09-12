import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:todos/controllers/todos_list_controller.dart';
import 'package:todos/screens/todo_list.dart';
import 'package:todos/src/database/database.dart';

void main() {
  runApp(GetMaterialApp(
    home: HomePage(title: 'TODOs App'),
    onInit: () => _registerDependencies(),
    onDispose: () {
      debugPrint('in onDispose');
      _unRegisterDependencies();
    },
  ));
}

void _registerDependencies() {
  Get.put(TodosDatabase());
  Get.put(TodosListController());
}

void _unRegisterDependencies() {
  TodosDatabase db = Get.find();
  db.close();
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

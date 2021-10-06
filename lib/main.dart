import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/bindings/todo_detail_binding.dart';
import 'package:todos/bindings/todo_list_binding.dart';
import 'package:todos/repositories/amplify_todo_repository.dart';
import 'package:todos/repositories/todo_repository.dart';

import 'package:todos/screens/todo_detail.dart';
import 'package:todos/screens/todo_list.dart';

void main() async {
  runApp(TodosApp());
}

class TodosApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _TodosAppState createState() => _TodosAppState();
}

class _TodosAppState extends State<TodosApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _setupService();
    });
  }

  void _setupService() async {
    await AmplifyTodoRepository.configure();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onInit: _registerDependencies,
      initialRoute: '/todos',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
            name: '/todos', page: () => TodoList(), binding: TodoListBinding()),
        GetPage(
            name: '/todos/new',
            page: () => TodoDetail(),
            binding: TodoDetailBinding()),
        GetPage(
            name: '/todos/:id',
            page: () => TodoDetail(),
            binding: TodoDetailBinding())
      ],
      // onInit: () async => await _registerDependencies(),
    );
  }
}

void _registerDependencies() {
  Get.put<TodoRepository>(AmplifyTodoRepository());
}

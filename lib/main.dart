import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:todos/bindings/todo_detail_binding.dart';
import 'package:todos/bindings/todo_list_binding.dart';
import 'package:todos/repositories/amplify_todo_repository.dart';
import 'package:todos/repositories/todo_repository.dart';

import 'package:todos/screens/todo_detail.dart';
import 'package:todos/screens/todo_list.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(TodosApp());
}

class TodosApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _TodosAppState createState() => _TodosAppState();
}

class _TodosAppState extends State<TodosApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _initialiseApp();
  }

  Future<void> _initialiseApp() async {
    await AmplifyTodoRepository.configure();

    setState(() {
      _isAmplifyConfigured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAmplifyConfigured) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todos/bindings/app_bindings.dart';
import 'package:todos/bindings/login_binding.dart';

import 'package:todos/bindings/todo_detail_binding.dart';
import 'package:todos/bindings/todo_list_binding.dart';
import 'package:todos/screens/loading.dart';
import 'package:todos/screens/login.dart';

import 'package:todos/screens/todo_detail.dart';
import 'package:todos/screens/todo_list.dart';
import 'package:todos/services/amplify_utils.dart' as amplifyUtils;

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
  bool _appInitialised = false;

  @override
  void initState() {
    super.initState();
    _initialiseApp();
  }

  Future<void> _initialiseApp() async {
    await amplifyUtils.configure();

    setState(() {
      _appInitialised = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_appInitialised) {
      return MaterialApp(
        home: Scaffold(
          body: Loading(),
        ),
      );
    }

    return GetMaterialApp(
        initialBinding: AppBindings(),
        debugShowCheckedModeBanner: false,
        title: 'Todos',
        home: Loading(),
        getPages: _getRoutes());
  }

  List<GetPage> _getRoutes() {
    return [
      GetPage(name: '/login', page: () => Login(), binding: LoginBinding()),
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
    ];
  }
}

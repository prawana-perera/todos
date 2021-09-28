import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/bindings/todo_detail_binding.dart';
import 'package:todos/bindings/todo_list_binding.dart';

import 'package:todos/screens/todo_detail.dart';
import 'package:todos/screens/todo_list.dart';
import 'package:todos/src/database/database.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/todos',
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
    onInit: () => _registerDependencies(),
    onDispose: () {
      debugPrint('in onDispose');
      _unRegisterDependencies();
    },
  ));
}

void _registerDependencies() {
  Get.put(TodosDatabase());
}

void _unRegisterDependencies() {
  TodosDatabase db = Get.find();
  db.close();
}

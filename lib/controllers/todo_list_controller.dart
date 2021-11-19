import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/models/data_event_subscription.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todo_repository.dart';

import 'auth_controller.dart';

class TodosListController extends GetxController {
  final _todoRepository = Get.find<TodoRepository>();
  final _authController = Get.find<AuthController>();

  DataEventSubscription? _newTodosSubscription;

  List<Todo> todos = <Todo>[].obs;
  var isLoading = false.obs;

  @override
  onInit() {
    getAll();
    super.onInit();
  }

  void getAll() async {
    try {
      isLoading(true);
      final allTodos = await _todoRepository.getAll();
      print('all todos' + allTodos.toString());
      todos.assignAll(allTodos);
      // TODO: repo query should sort first
      todos.sort((a, b) => b.priority.compareTo(a.priority));

      if (_newTodosSubscription == null) {
        _subscribeToNewTodos();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      debugPrint('DONE');
      isLoading(false);
    }
  }

  void _subscribeToNewTodos() {
    _newTodosSubscription = _todoRepository.subscribe(
      _authController.loggedInUser.value!,
      onCreate: (Todo todo) {
        todos.add(todo);
        todos.sort((a, b) => b.priority.compareTo(a.priority));
      },
      onUpdate: (Todo todo) {
        todos.removeWhere((element) => element.id == todo.id);
        todos.add(todo);
        todos.sort((a, b) => b.priority.compareTo(a.priority));
      },
      onDelete: (String id) {
        todos.removeWhere((element) => element.id == id);
        todos.sort((a, b) => b.priority.compareTo(a.priority));
      },
    );
  }

  @override
  void onClose() {
    if (_newTodosSubscription != null) {
      _newTodosSubscription!.cancel();
    }

    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/controllers/mixins/authentication.dart';
import 'package:todos/models/data_event_subscription.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/update_result.dart';
import 'package:todos/repositories/todo_repository.dart';

class TodosListController extends GetxController with Authentication {
  final _todoRepository = Get.find<TodoRepository>();

  DataEventSubscription? _newTodosSubscription;

  List<Todo> todos = <Todo>[].obs;
  var isLoading = false.obs;

  @override
  onInit() {
    getAll();
    super.onInit();
  }

  @override
  void onClose() {
    if (_newTodosSubscription != null) {
      _newTodosSubscription!.cancel();
    }

    super.onClose();
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
      throw e;
    } finally {
      debugPrint('DONE');
      isLoading(false);
    }
  }

  void _subscribeToNewTodos() {
    _newTodosSubscription = _todoRepository.subscribe(
      user!,
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

  void navigateToDetails(String? id) async {
    UpdateResult result = id == null
        ? await Get.toNamed('/todos/new')
        : await Get.toNamed('/todos/$id');

    if (result.status == UpdateStatus.none) {
      return;
    }

    var message = '';

    switch (result.status) {
      case UpdateStatus.created:
        message = '${result.todo!.title} added.';
        break;
      case UpdateStatus.updated:
        message = '${result.todo!.title} updated.';
        break;
      case UpdateStatus.deleted:
        message = '${result.todo!.title} deleted.';
        break;
      default: // Without this, you see a WARNING.
    }

    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(message,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18)),
        isDismissible: true,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

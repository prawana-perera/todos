import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todo_repository.dart';

class TodosListController extends GetxController {
  final todoRepository = Get.find<TodoRepository>();

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
      final allTodos = await todoRepository.getAll();
      print('all todos' + allTodos.toString());
      todos.assignAll(allTodos);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      debugPrint('DONE');
      isLoading(false);
    }
  }
}

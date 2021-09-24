import 'package:get/get.dart';
import 'package:todos/controllers/todo_list_controller.dart';

class TodoListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodosListController>(() => TodosListController());
  }
}

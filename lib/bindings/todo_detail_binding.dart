import 'package:get/get.dart';
import 'package:todos/controllers/todo_detail_controller.dart';

class TodoDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoDetailController>(() => TodoDetailController());
  }
}

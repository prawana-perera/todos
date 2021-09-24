import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/src/database/database.dart';

class TodosListController extends GetxController {
  TodosDatabase _db = Get.find();

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
      final allTodos = await _db.getAllTodos();
      todos.assignAll(allTodos);
    } catch(e) {
      debugPrint(e.toString());
    }finally {
      debugPrint('DONE');
      isLoading(false);
    }
  }
}

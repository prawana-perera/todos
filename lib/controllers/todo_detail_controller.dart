import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/src/database/database.dart';
import 'package:moor/moor.dart' as moor;

class TodoDetailController extends GetxController {
  TodosDatabase _db = Get.find();

  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var isLoading = false.obs;
  var title = ''.obs;
  var priority = 1.obs;
  var description = ''.obs;
  var pageTitle = 'Add a todo'.obs;

  Todo? _todo;

  @override
  onInit() async {
    String? id = Get.parameters['id'];

    if (id != null) {
      _fetchTodo(int.parse(id));
      pageTitle('Edit todo');
    }

    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _fetchTodo(int id) async {
    try {
      isLoading(true);
      _todo = await _db.getTodo(id);

      // Handle in case todo not found, throw error? Navigate back with message
      titleController.text = _todo!.title;
      descriptionController.text = _todo!.description!;
      priority(_todo!.priority);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      debugPrint('DONE');
      isLoading(false);
    }
  }

  Future deleteTodo() async {
    await _db.deleteTodo(_todo!);
  }

  Future saveTodo() async {
    var now = DateTime.now().toUtc();

    if (_todo == null) {
      var todo = TodosCompanion.insert(
          title: titleController.text,
          // Not good, better way to solve
          description: moor.Value(descriptionController.text),
          priority: priority.value,
          createdAt: now,
          updatedAt: now);

      await _db.addTodo(todo);
    } else {
      Todo todo = _todo!.copyWith(
          title: titleController.text,
          description: descriptionController.text,
          priority: priority.value,
          updatedAt: now);

      await _db.updateTodo(todo);
    }
  }
}

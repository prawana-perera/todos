import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/models/Todo.dart';
import 'package:todos/repositories/todo_repository.dart';

class TodoDetailController extends GetxController {
  final _todoRepository = Get.find<TodoRepository>();

  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var isLoading = false.obs;
  var title = ''.obs;
  var priority = 1.obs;
  var description = ''.obs;
  var pageTitle = 'Add a todo'.obs;
  var isEditing = false.obs;

  Todo? _todo;

  @override
  onInit() async {
    String? id = Get.parameters['id'];

    if (id != null) {
      _fetchTodo(id);
      pageTitle('Edit todo');
      isEditing(true);
    }

    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _fetchTodo(String id) async {
    try {
      isLoading(true);
      _todo = await _todoRepository.getById(id);

      // Handle in case todo not found, throw error? Navigate back with message
      titleController.text = _todo!.name;
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
    await _todoRepository.delete(_todo!);
  }

  Future saveTodo() async {
    // var now = DateTime.now().toUtc();

    if (_todo == null) {
      _todo = Todo(
          name: titleController.text,
          description: descriptionController.text,
          priority: priority.value);
    } else {
      _todo = _todo!.copyWith(
          name: titleController.text,
          description: descriptionController.text,
          priority: priority.value);
    }

    _todoRepository.save(_todo!);
  }

  Todo? get todo {
    return _todo;
  }
}

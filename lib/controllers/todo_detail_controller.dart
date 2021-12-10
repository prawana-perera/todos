import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/update_result.dart';
import 'package:todos/repositories/todo_repository.dart';

class TodoDetailController extends GetxController {
  final _todoRepository = Get.find<TodoRepository>();

  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var isLoading = false.obs;
  var title = ''.obs;
  var priority = 'LOW'.obs;
  var description = ''.obs;
  var pageTitle = 'Add a todo'.obs;
  var isEditing = false.obs;

  Todo? _todo;

  Todo? get todo {
    return _todo;
  }

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
    await _todoRepository.delete(_todo!);
    back(result: UpdateResult(UpdateStatus.deleted, todo));
  }

  Future saveTodo() async {
    if (formKey.currentState!.validate()) {
      if (_todo == null) {
        _todo = Todo(null, titleController.text, descriptionController.text,
            priority.value);
        await _todoRepository.add(_todo!);
      } else {
        _todo = Todo(_todo!.id, titleController.text,
            descriptionController.text, priority.value);
        await _todoRepository.update(_todo!);
      }

      if (isEditing.value) {
        back(result: UpdateResult(UpdateStatus.updated, todo));
      } else {
        back(result: UpdateResult(UpdateStatus.created, todo));
      }
    }
  }

  void back(
      {UpdateResult result = const UpdateResult(UpdateStatus.none, null)}) {
    Get.back(result: result);
  }
}

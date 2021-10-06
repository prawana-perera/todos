import 'package:todos/models/Todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAll();
  Future<Todo> getById(String id);
  Future<Todo> save(Todo todo);
  Future<void> delete(Todo todo);
}

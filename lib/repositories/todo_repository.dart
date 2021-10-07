import 'package:todos/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAll();
  Future<Todo> getById(String id);
  Future<Todo> add(Todo todo);
  Future<Todo> update(Todo todo);
  Future<void> delete(Todo todo);
}

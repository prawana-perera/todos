import 'package:todos/models/data_event_subscription.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/user.dart';

typedef void OnCreate(Todo todo);
typedef void OnUpdate(Todo todo);
typedef void OnDelete(String id);

abstract class TodoRepository {
  Future<List<Todo>> getAll();
  Future<Todo> getById(String id);
  Future<Todo> add(Todo todo);
  Future<Todo> update(Todo todo);
  Future<void> delete(Todo todo);

  DataEventSubscription subscribe(User user,
      {required OnCreate onCreate,
      required OnUpdate onUpdate,
      required OnDelete onDelete});
}

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as m;
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:todos/src/database/database.dart';

void main() {
  late TodosDatabase db;

  setUp(() {
    db = TodosDatabase.test(VmDatabase.memory());
  });

  group('addTodo', () {
    test('should create a todo', () async {
      final createdAt = DateTime.parse('2021-02-27 13:27:00');
      final updatedAt = DateTime.parse('2021-02-28 13:27:00');
      final id = await db.addTodo(TodosCompanion.insert(
          title: 'Java',
          priority: 1,
          createdAt: createdAt,
          updatedAt: updatedAt,
          description: Value('Do Java')));

      var todo = await (db.select(db.todos)..where((t) => t.id.equals(id)))
          .getSingle();
      expect(todo.title, equals('Java'));
      expect(todo.priority, equals(1));
      expect(todo.createdAt, equals(createdAt));
      expect(todo.updatedAt, equals(updatedAt));
      expect(todo.description, equals('Do Java'));
    });
  });

  group('getAllTodos', () {
    setUp(() async {
      await db.into(db.todos).insert(TodosCompanion.insert(
          title: 'Java',
          priority: 1,
          createdAt: DateTime.parse('2021-02-27 13:27:00'),
          updatedAt: DateTime.parse('2021-02-28 13:27:00'),
          description: Value('Do Java')));
      await db.into(db.todos).insert(TodosCompanion.insert(
          title: 'Ruby',
          priority: 3,
          createdAt: DateTime.parse('2021-03-27 13:27:00'),
          updatedAt: DateTime.parse('2021-03-28 13:27:00'),
          description: Value('Do Ruby')));
    });

    test('should get all todos', () async {
      var todos = await db.getAllTodos();
      expect(todos, hasLength(2));
    });
  });

  group('deleteTodo', () {
    late Todo todo;
    setUp(() async {
      final id = await db.into(db.todos).insert(TodosCompanion.insert(
          title: 'Java',
          priority: 1,
          createdAt: DateTime.parse('2021-02-27 13:27:00'),
          updatedAt: DateTime.parse('2021-02-28 13:27:00'),
          description: Value('Do Java')));
      todo = await (db.select(db.todos)..where((t) => t.id.equals(id)))
          .getSingle();
    });

    test('should delete the todo', () async {
      await db.deleteTodo(todo);

      final Todo? deletedTodo = await (db.select(db.todos)
            ..where((t) => t.id.equals(todo.id)))
          .getSingleOrNull();
      expect(deletedTodo, m.isNull);
    });
  });

  tearDown(() {
    db.close();
  });
}

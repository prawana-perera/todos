import 'package:flutter_test/flutter_test.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/main.dart';
import 'package:todos/screens/tododetail.dart';
import 'package:todos/screens/todolist.dart';

void main() {
  group('toMap', () {
    test('should return map of values', () {
      final todo =
          Todo.withId(99, 'Learn Java', 1, '2021-11-11', 'Learn java 15');
      final map = todo.toMap();
      expect(map, isNotNull);
      expect(map, containsPair("id", todo.id));
      expect(map, containsPair("title", todo.title));
      expect(map, containsPair("description", todo.description));
      expect(map, containsPair("priority", todo.priority));
      expect(map, containsPair("date", todo.date));
    });
  });

  group('constructors', () {
    group('fromObject', () {
      test('should create a todo', () {
        final obj = <String, dynamic>{};
        obj['id'] = 99;
        obj['title'] = 'Learn Java';
        obj['priority'] = 1;
        obj['date'] = '2021-11-11';
        obj['description'] = 'Learn java 15';

        final todo = Todo.fromObject(obj);
        expect(todo, isNotNull);
        expect(todo.id, equals(obj['id']));
        expect(todo.title, equals(obj['title']));
        expect(todo.priority, equals(obj['priority']));
        expect(todo.date, equals(obj['date']));
        expect(todo.description, equals(obj['description']));
      });
    });
  });
}

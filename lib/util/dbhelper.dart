import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos/model/todo.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() => _dbHelper;

  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initialiseDb();
    }

    return _db as Database;
  }

  Future<Database> initialiseDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todos.db';
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, priority INTEGER, date TEXT)');
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert("todos", todo.toMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * from todos ORDER BY priority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result =
        Sqflite.firstIntValue(await db.rawQuery("select count(*) from todos"));
    return result == null ? 0 : result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db
        .update("todos", todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    var result = await db.delete("todos", where: "id = ?", whereArgs: [id]);
    return result;
  }
}

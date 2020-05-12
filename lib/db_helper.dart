import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/todo.dart';

class DBHelper {
  static Database _db;

  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String ISDONE = 'isDone';
  static const String TABLE = 'Todo';
  static const String DB_NAME = 'todo.db';

  Future<Database> get db async {
    return _db != null ? _db : await initDb();
  }

  Future<Database> initDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, DB_NAME);
    final db = await openDatabase(path, version: 1, onCreate: _oncCreate);
    return db;
  }

  FutureOr<void> _oncCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $TABLE 
        (
          $ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          $TITLE TEXT NOT NULL,
          $ISDONE INTEGER DEFAULT 0
        );''');
  }

  Future<int> addTodo(Todo todo) async {
    final dbClient = await db;
    todo.id = await dbClient.insert(TABLE, todo.toMap());
    return todo.id;
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final dbClient = await db;
    var result = await dbClient.query(TABLE, orderBy: '$ISDONE ASC');
    return result;
  }

  Future<int> markDone(Todo todo) async {
    final dbClient = await db;
    return await dbClient
        .update(TABLE, todo.toMap(), where: '$ID = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    final dbClient = await db;
    return dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> deleteTodoMarkedAsDone() async {
    final dbClient = await db;
    return dbClient.delete(TABLE, where: '$ISDONE = 1');
  }

  Future<void> close() async {
    final dbClient = await db;
    dbClient.close();
  }

  Future<List<Todo>> getTodosList() async {
    var map = await getTodos();
    List<Todo> todoList = List<Todo>();

    for (final m in map) {
      todoList.add(Todo.fromMap(m));
    }

    return todoList;
  }
}

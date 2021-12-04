import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

const String tableName = 'todo';
const String columnId = 'id';
const String columnContent = 'content';
const String columnIsDone = 'isDone';

class Todo {
  late int? id;
  late String content;
  // late bool isDone;

  Todo({this.id, required this.content});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnId: id,
      columnContent: content,
      // columnIsDone: isDone,
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    // isDone = map[columnIsDone];
    debugPrint('$id, $content');
  }
  // @override
  // String toString() {
  //   return "Todo{id: $id, content: $content, isDone: $isDone}";
  // }
}

class TodoProvider {
  late Database _database;

  Future<Database> get database async{
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName(
          $columnId integer primary key autoincrement,
          $columnContent text not null
          '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<Todo> insert(Todo todo) async {
    final db = await database;
    print(todo.toMap());
    todo.id = await db.insert(tableName, todo.toMap());
    return todo;
  }
}
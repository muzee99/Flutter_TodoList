import 'dart:async';
import 'package:flutter/cupertino.dart';
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
  late int isDone;

  Todo({this.id, required this.content, required this.isDone});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnId: id,
      columnContent: content,
      columnIsDone: isDone,
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    isDone = map[columnIsDone];
    debugPrint('$id, $content, $isDone');
  }
}

class TodoProvider {
  late Database _database;

  Future<Database> get database async{
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'todo_database2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $columnContent TEXT NOT NULL,
          $columnIsDone INTEGER NOT NULL
          )''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion){}
    );

  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    debugPrint("++++insertTodo++++");
    todo.id = await db.insert(tableName, todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    debugPrint("++++updateTodo++++");
    await db.update(
      tableName, 
      todo.toMap(), 
      where: "$columnId = ?", 
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int? id) async {
    debugPrint('++++deleteTodo++++');
    final db = await database;
    debugPrint("deleteTodo : $id");
    await db.delete(
      tableName,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  Future<List<Todo>> todoItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    if(!maps.isNotEmpty) return [];
    return List.generate(maps.length, (index) {
      return Todo(
        id: maps[index][columnId],
        content: maps[index][columnContent],
        isDone: maps[index][columnIsDone],
      );
    });
  }
}
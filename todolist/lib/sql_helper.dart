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
    String path = join(await getDatabasesPath(), 'todo_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $columnContent TEXT NOT NULL
          )''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    print("++++updateTodo++++");
    print(todo.toMap());
    // print(await db.insert(tableName, todo.toMap()));
    todo.id = await db.insert(tableName, todo.toMap());
    print(todo.id);
    // final List<Map<String, dynamic>> elsa = await db.query(tableName, where: "$columnId : ?", whereArgs: [todo.id]);
    // print(await db.query(tableName, where: "$columnId : ?", whereArgs: [todo.id]));
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    print("updateTodo : $todo.toMap()");
    await db.update(
      tableName, 
      todo.toMap(), 
      where: "$columnId = ?", 
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    print("deleteTodo : $id");
    await db.delete(
      tableName,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  Future<List<Todo>> todoItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Todo(
        id: maps[index][columnId],
        content: maps[index][columnContent],
      );
    });
    // List<Todo> todoList = maps.isNotEmpty ? maps.map((e) => Todo(id:e[columnId], content: e[columnContent])).toList() : [];
    // return todoList;
  }

  // List<Todo> getTodoItems() {
    
  // }

  Future<void> printTodoItems() async{
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    print("++++printTodoItems++++");
    List<Todo> list = List.generate(maps.length, (index) {
      return Todo(
        id: maps[index][columnId],
        content: maps[index][columnContent],
      );
    });
    print(list.map((e) => e.toMap()));
  }
}
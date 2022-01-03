import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sql_helper.dart';
import 'todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      theme: ThemeData(
        fontFamily: 'SooMyeongjo',
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var provider = TodoProvider();
  final _addTextController = TextEditingController();
  final _editTextController = TextEditingController();
  final _todoList = <Todo>{};
  List<Todo> items = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void handleListChanged(Todo item) {
    setState(() {
      Todo newItem;
      if(item.isDone==0) {
        newItem = Todo(content: item.content, id: item.id, isDone: 1);
        _todoList.add(item);
      }
      else {
        newItem = Todo(content: item.content, id: item.id, isDone: 0);
        _todoList.remove(item);
      }
      provider.updateTodo(newItem);
      _loadTodoList();
    });
  }
  
  Future<void> _insertDB(String content) async {
    var todo = Todo(content: content, isDone: 1);
    provider.insertTodo(todo);
  }

  void _loadTodoList() async { 
    List<Todo> newList = await provider.todoItems(); 
    setState(() { 
      items = newList; 
    });
  }
  
  void _deleteDone() {
    setState(() {
      for(int i=0; i<items.length; i++) {
        if(items[i].isDone==0) provider.deleteTodo(items[i].id);
      }
      _loadTodoList();
      Fluttertoast.showToast(
        msg: "Done items are all deleted.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
    });
  }

  void _deleteAll() {
    setState(() {
      for(int i=0; i<items.length; i++) {
        provider.deleteTodo(items[i].id);
      }
      _loadTodoList();
      Fluttertoast.showToast(
        msg: "All items are deleted.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
      );
    });
  }

  void _editTodo(Todo item, String content) {
    Todo newItem = Todo(content: content, id: item.id, isDone: item.isDone);
    setState(() {
      provider.updateTodo(newItem);
      _loadTodoList();
    });
    Fluttertoast.showToast(msg: 'edit todo item');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {print(DateTime.now());},),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _deleteDone, 
                    child: const Text('delete Done')),
                  OutlinedButton(
                    onPressed: _deleteAll, 
                    child: const Text('delete All')),
                ],
              ),
              SizedBox(
                child: TextField(
                  controller: _addTextController,
                  decoration: InputDecoration(
                    labelText: 'To do',
                    suffixIcon: IconButton(
                      onPressed: _addTextController.clear, 
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onSubmitted: (String str) {
                    setState(() {
                      _insertDB(str);
                      _loadTodoList();
                      _addTextController.clear();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: items.map((Todo item) {
                    return TodoListItem(
                      item: item,
                      onListChanged: handleListChanged,
                      deleteListTile: (item) {
                        provider.deleteTodo(item.id);
                        Fluttertoast.showToast(msg: 'delete todo item');
                        _loadTodoList();
                      },
                      editListTile: (item) {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('edit todo'),
                              content: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _editTextController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: 'Edit Todo',
                                            suffixIcon: IconButton(onPressed: _editTextController.clear, icon: const Icon(Icons.clear)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('edit'),
                                  onPressed: () {
                                    _editTodo(item, _editTextController.text);
                                    _editTextController.clear();
                                    Navigator.of(context).pop();
                                  }
                                ),
                                TextButton(
                                  child: const Text('cancel'),
                                  onPressed: () {
                                    _editTextController.clear();
                                    Navigator.of(context).pop();
                                  }
                                )
                              ],
                            );
                          });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
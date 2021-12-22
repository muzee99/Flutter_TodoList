import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sql_helper.dart';
import 'todo_list.dart';
//
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
        primarySwatch: Colors.yellow,
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
  final _controller = TextEditingController();
  final _todoList = <Todo>{};
  List<Todo> items = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void handleListChanged(Todo item) {
    print('ListTile of TodoList is on Tapped. The state of isDone');
    print(item.isDone);
    setState(() {
      var newItem;
      if(item.isDone==0) {
        print('item.isDone is 0.');
        newItem = Todo(content: item.content, id: item.id, isDone: 1);
        _todoList.add(item);
      }
      else {
        print('item.isDone is 1.');
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
    // provider.printTodoItems();
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
      // items.map((e) {
      //   print('_deleteDone() >> items.map');
      //   if(e.isDone==0) provider.deleteTodo(e.id);
      // });
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
      // items.map((e) {
      //   print('_deleteDone() >> items.map');
      //   if(e.isDone==0) provider.deleteTodo(e.id);
      // });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          // color: Colors.blue,
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
              const Text(
                'Please input what to do.',
                // style: TextStyle(fontFamily: "SooMyeongjo", fontSize: 20),
              ),
              SizedBox(
                child: TextField(
                  controller: _controller,
                  // autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'To do',
                    suffixIcon: IconButton(
                      onPressed: _controller.clear, 
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onSubmitted: (String str) {
                    setState(() {
                      _insertDB(str);
                      _loadTodoList();
                      _controller.clear();
                    });
                  },
                ),
              ),
              Expanded(
                // child: TodoList(
                //   items: items,
                // ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: items.map((Todo item) {
                    return TodoListItem(
                      item: item,
                      onListChanged: handleListChanged,
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
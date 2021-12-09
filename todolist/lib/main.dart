import 'package:flutter/material.dart';
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
  List<Todo> items = [];
  // List<Todo> items = await provider.todoItems();
  final _controller = TextEditingController();

  Future<void> _insertDB(String content) async {
    var todo = Todo(content: content);
    provider.insertTodo(todo);
    // provider.printTodoItems();
  }

  void _loadTodoList() async { 
    List<Todo> newList = await provider.todoItems(); 
    setState(() { 
      items = newList; 
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
              const Text(
                'Please input what to do.',
                // style: TextStyle(fontFamily: "SooMyeongjo", fontSize: 20),
              ),
              SizedBox(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'To do',
                    suffixIcon: IconButton(
                      onPressed: _controller.clear, 
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onSubmitted: (String str) {
                    setState(() {
                      _loadTodoList();
                      debugPrint(str);
                      _insertDB(str);
                      _controller.clear();
                    });
                  },
                ),
              ),
              Expanded(
                child: TodoList(
                  items: items,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
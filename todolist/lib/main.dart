import 'package:flutter/material.dart';
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

typedef ListChangeCallback = Function(Todo item);

class TodoListItem extends StatelessWidget{

  TodoListItem({
    required this.item,
    // required this.isDone,
    required this.onListChanged,
  }) : super(key: ObjectKey(item));

  final Todo item;
  // final bool isDone;
  final ListChangeCallback onListChanged;

  Color getColor(BuildContext context) {
    if(item.isDone==0) return Colors.black54;
    return Theme.of(context).primaryColor;
  }

  TextStyle? getTextStyle(BuildContext context) {
    if(item.isDone==0) return null;
    return const TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item);
      },
      leading: CircleAvatar(
        backgroundColor: getColor(context),
      ),
      title: Text(
        item.content, 
        style: getTextStyle(context),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  TodoList({required this.items, Key?key}) : super(key:key);

  List<Todo> items;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _todoList = <Todo>{};

  void handleListChanged(Todo item) {
    print('ListTile of TodoList is on Tapped. The state of isDone');
    print(item.isDone);
    setState(() {
      if(item.isDone==0) {_todoList.add(item);}
      else {_todoList.remove(item);}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: widget.items.map((Todo item) {
        return TodoListItem(
          item: item,
          onListChanged: handleListChanged,
        );
      }).toList(),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var provider = TodoProvider();
  final _controller = TextEditingController();
  final _todoList = <Todo>{};

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  void handleListChanged(Todo item) {
    print('ListTile of TodoList is on Tapped. The state of isDone');
    print(item.isDone);
    setState(() {
      if(item.isDone==0) {_todoList.add(item);}
      else {_todoList.remove(item);}
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

  List<Todo> items = [];
  
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
                      // debugPrint(str);
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
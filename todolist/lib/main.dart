import 'package:flutter/material.dart';

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

// class TodoItem {
//   const TodoItem({required this.content});
//   final String content;
// }

// typedef ListChangeCallback = Function(TodoItem item, bool isDone);

// class TodoListItem extends StatelessWidget{

//   TodoListItem({
//     required this.item,
//     required this.isDone,
//     required this.onListChanged,
//   }) : super(key: ObjectKey(item));

//   final TodoItem item;
//   final bool isDone;
//   final ListChangeCallback onListChanged;

//   Color getColor(BuildContext context) {
//     return isDone ? Colors.black54 : Theme.of(context).primaryColor;
//   }

//   TextStyle? getTextStyle(BuildContext context) {
//     if(!isDone) return null;
//     return const TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         onListChanged(item, isDone);
//       },
//       leading: CircleAvatar(
//         backgroundColor: getColor(context),
//       ),
//       title: Text(
//         item.content, 
//         style: getTextStyle(context),
//       ),
//     );
//   }
// }

// class TodoList extends StatefulWidget {
//   const TodoList({required this.items, Key?key}) : super(key:key);

//   final List<TodoItem> items;

//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   final _todoList = <TodoItem>{};

//   void handleListChanged(TodoItem item, bool isDone) {
//     setState(() {
//       if(!isDone) _todoList.add(item);
//       else _todoList.remove(item);
//     });
//   }
// }


class _MyHomePageState extends State<MyHomePage> {
  String data = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please input what to do.',
            ),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'To do',
                ),
                onSubmitted: (String str) {
                  setState(() {
                    data = str;
                  });
                },
              ),
            ),
            Text(data),
          ],
        ),
      ),
    );
  }
}

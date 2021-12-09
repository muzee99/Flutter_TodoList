import 'package:flutter/material.dart';
import 'sql_helper.dart';

// class TodoItem {
//   const TodoItem({required this.content, required this.isDone});
//   final String content;
//   final bool isDone;
// }

typedef ListChangeCallback = Function(Todo item, bool isDone);

class TodoListItem extends StatelessWidget{

  TodoListItem({
    required this.item,
    required this.isDone,
    required this.onListChanged,
  }) : super(key: ObjectKey(item));

  final Todo item;
  final bool isDone;
  final ListChangeCallback onListChanged;

  Color getColor(BuildContext context) {
    return isDone ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle? getTextStyle(BuildContext context) {
    if(!isDone) return null;
    return const TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, isDone);
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

  void handleListChanged(Todo item, bool isDone) {
    setState(() {
      if(!isDone) {_todoList.add(item);}
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
          isDone: _todoList.contains(item),
          onListChanged: handleListChanged,
        );
      }).toList(),
    );
  }
}

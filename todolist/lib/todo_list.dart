import 'package:flutter/material.dart';
import 'sql_helper.dart';

typedef ListChangeCallback = Function(Todo item);
typedef EditListTile = Function(Todo item);
typedef DeleteListTile = Function(Todo item);

class TodoListItem extends StatelessWidget{

  TodoListItem({
    required this.item,
    required this.editListTile,
    required this.deleteListTile,
    required this.onListChanged,
    
  }) : super(key: ObjectKey(item));

  final Todo item;
  final ListChangeCallback onListChanged;
  final EditListTile editListTile;
  final DeleteListTile deleteListTile;

  Color getColor(BuildContext context) {
    if(item.isDone==0) return Colors.black54;
    return Theme.of(context).primaryColor;
  }

  TextStyle? getTextStyle(BuildContext context) {
    if(item.isDone==1) return null;
    return const TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item);
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: Center(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('delete'),
                      onTap: () {
                        deleteListTile(item);
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: const Text('edit'),
                      onTap:() {
                        Navigator.of(context).pop();
                        editListTile(item);
                      },
                    ),
                  ],
                ),
              ),
            );
        });
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

// class TodoList extends StatefulWidget {
//   TodoList({required this.items, Key?key}) : super(key:key);

//   List<Todo> items;

//   @override
//   _TodoListState createState() => _TodoListState();
// }

// class _TodoListState extends State<TodoList> {
//   final _todoList = <Todo>{};

//   void handleListChanged(Todo item) {
//     setState(() {
//       if(item.isDone==0) {_todoList.add(item);}
//       else {_todoList.remove(item);}
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       children: widget.items.map((Todo item) {
//         return TodoListItem(
//           item: item,
//           onListChanged: handleListChanged,
//         );
//       }).toList(),
//     );
//   }
// }

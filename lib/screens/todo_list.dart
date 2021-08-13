import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/screens/todo_detail.dart';
import 'package:todos/util/db_helper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  Future<bool>? _todosFuture;
  List<Todo> _todos = [];

  DbHelper _helper = DbHelper();
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _todosFuture = _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _todosFuture,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return Scaffold(
              body: _todoListItems(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _navigateToDetails(Todo.empty());
                },
                tooltip: 'Add new Todo',
                child: new Icon(Icons.add),
              ),
            );
          }

          return Container();
        });
  }

  ListView _todoListItems() {
    return ListView.builder(
      itemCount: _count,
      itemBuilder: (BuildContext context, int position) {
        var todo = _todos[position];

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPrioritisedColor(todo.priority),
              child: Text(todo.priority.toString()),
            ),
            title: Text(todo.title),
            subtitle: Text(todo.date),
            onTap: () {
              _navigateToDetails(todo);
            },
          ),
        );
      },
    );
  }

  Color _getPrioritisedColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orangeAccent;
      default:
        return Colors.red;
    }
  }

  Future<bool> _getTodos() async {
    await _helper.initialiseDb();
    var todos = (await _helper.getTodos())
        .map((data) => Todo.fromObject(data))
        .toList();

    todos.sort((a, b) => b.priority.compareTo(a.priority));

    setState(() {
      _todos = todos;
      _count = todos.length;
    });

    return true;
  }

  void _navigateToDetails(Todo todo) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));

    if (result) {
      _getTodos();
    }
  }
}

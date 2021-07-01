import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/util/dbhelper.dart';

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
                onPressed: null,
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
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPrioritisedColor(_todos[position].priority),
              child: Text(_todos[position].priority.toString()),
            ),
            title: Text(_todos[position].title),
            subtitle: Text(_todos[position].date),
            onTap: () {
              debugPrint("Tapped on ${_todos[position].id.toString()}");
            },
          ),
        );
      },
    );
  }

  Color _getPrioritisedColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
  }

  Future<bool> _getTodos() async {
    await _helper.initialiseDb();
    await _helper.insertTodo(Todo("Go shopping", 1, DateTime.now().toString(), "Need to shop"));
    await _helper.insertTodo(Todo("Gardening", 3, DateTime.now().toString(), "Plant something"));
    var todos = (await _helper.getTodos())
        .map((data) => Todo.fromObject(data))
        .toList();

    setState(() {
      _todos = todos;
      _count = todos.length;
    });

    return true;
  }
}

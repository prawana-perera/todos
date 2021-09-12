import 'package:flutter/material.dart';
import 'package:todos/controllers/todos_list_controller.dart';
import 'package:todos/screens/todo_detail.dart';
import 'package:todos/src/database/database.dart';
import 'package:get/get.dart';

class TodoList extends StatelessWidget {
  final TodosListController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(_controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          body: _todoListItems(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _navigateToDetails(context, null);
            },
            tooltip: 'Add new Todo',
            child: new Icon(Icons.add),
          ),
        );
      }



    });
  }

  ListView _todoListItems() {
    return ListView.builder(
      itemCount: _controller.todos.length,
      itemBuilder: (BuildContext context, int position) {
        var todo = _controller.todos[position];

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPrioritisedColor(todo.priority),
              child: Text(todo.priority.toString()),
            ),
            title: Text(todo.title),
            // subtitle: Text(todo.date),
            onTap: () {
              _navigateToDetails(context, todo);
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

  void _navigateToDetails(BuildContext context, Todo? todo) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));

    if (result) {
      _controller.getAll();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:todos/controllers/todo_list_controller.dart';
import 'package:get/get.dart';

class TodoList extends StatelessWidget {
  final TodosListController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todos'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
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
      }),
    );
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
              _navigateToDetails(context, todo.id);
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

  void _navigateToDetails(BuildContext context, int? id) async {
    bool updated = id == null
        ? await Get.toNamed('/todos/new')
        : await Get.toNamed('/todos/$id');

    if (updated) {
      _controller.getAll();
    }
  }
}

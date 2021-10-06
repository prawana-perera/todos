import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos/controllers/todo_list_controller.dart';
import 'package:get/get.dart';
import 'package:todos/models/update_result.dart';

class TodoList extends StatelessWidget {
  final TodosListController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                colorFilter: _controller.todos.isEmpty
                    ? null
                    : ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage('assets/images/todos_background.png'),
                fit: BoxFit.scaleDown)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('My Todos'),
          ),
          body: _controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : _todoListItems(),
          floatingActionButton: Container(
            height: 100.0,
            width: 100.0,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _navigateToDetails(null);
                },
                tooltip: 'Add new Todo',
                child: new Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
    });
  }

  ListView _todoListItems() {
    return ListView.builder(
      itemCount: _controller.todos.length,
      itemBuilder: (BuildContext context, int position) {
        var todo = _controller.todos[position];

        return Card(
          color: Colors.white.withOpacity(0.6),
          elevation: 2.0,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
              backgroundColor: _getPrioritisedColor(todo.priority),
              child: Text(todo.priority.toString()),
            ),
            title: Text(todo.name,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            // subtitle: Text(todo.date),
            onTap: () {
              _navigateToDetails(todo.id);
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

  void _navigateToDetails(String? id) async {
    UpdateResult result = id == null
        ? await Get.toNamed('/todos/new')
        : await Get.toNamed('/todos/$id');

    if (result.status == UpdateStatus.none) {
      return;
    }

    var message = '';

    switch (result.status) {
      case UpdateStatus.created:
        message = '${result.todo!.name} added.';
        break;
      case UpdateStatus.updated:
        message = '${result.todo!.name} updated.';
        break;
      case UpdateStatus.deleted:
        message = '${result.todo!.name} deleted.';
        break;
      default: // Without this, you see a WARNING.
    }

    Get.showSnackbar(
      GetBar(
        messageText: Text(message,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18)),
        isDismissible: true,
        duration: Duration(seconds: 3),
      ),
    );

    _controller.getAll();
  }
}

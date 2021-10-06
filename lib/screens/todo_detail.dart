import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/todo_detail_controller.dart';
import 'package:todos/models/update_result.dart';

const priorityMap = {1: 'Low', 2: 'Medium', 3: 'High'};

const menuShare = 'Share';
const menuDelete = 'Delete';

const menuIconMap = {menuDelete: Icons.delete, menuShare: Icons.share};

class TodoDetail extends StatelessWidget {
  final TodoDetailController _controller = Get.find();

  final _actionChoices = [menuDelete, menuShare];

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline6;

    return Form(
        key: _controller.formKey,
        child: Scaffold(
          appBar: AppBar(
              title: Text(_controller.pageTitle.value),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _back(),
              ),
              actions: _controller.isEditing.value
                  ? <Widget>[
                      PopupMenuButton(
                          onSelected: _selectAction,
                          itemBuilder: (BuildContext context) => _actionChoices
                              .map((String choice) => PopupMenuItem<String>(
                                  value: choice,
                                  child: ListTile(
                                    leading: Icon(menuIconMap[choice]),
                                    title: Text(choice),
                                  )))
                              .toList())
                    ]
                  : null),
          body: Padding(
            padding: EdgeInsets.only(top: 35, left: 10, right: 10),
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  TextFormField(
                    controller: _controller.titleController,
                    style: textStyle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      if (value.length > 20) {
                        return 'Please enter title less that 20 chars';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: TextFormField(
                      controller: _controller.descriptionController,
                      style: textStyle,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  ListTile(
                    title: Obx(() {
                      return DropdownButton<String>(
                        items: priorityMap.entries
                            .map((p) => DropdownMenuItem<String>(
                                  child: Text(p.value),
                                  value: p.key.toString(),
                                ))
                            .toList(),
                        style: textStyle,
                        value: _controller.priority.toString(),
                        onChanged: (String? value) {
                          if (value != null) {
                            _controller.priority(int.parse(value));
                          }
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              _save();
                            },
                            label: Text('Save'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ]),
          ),
        ));
  }

  void _selectAction(String value) {
    switch (value) {
      case menuDelete:
        _delete();
        break;
      default:
    }
  }

  void _delete() async {
    await _controller.deleteTodo();
    _back(result: UpdateResult(UpdateStatus.deleted, _controller.todo));
  }

  void _save() async {
    if (_controller.formKey.currentState!.validate()) {
      await _controller.saveTodo();

      if (_controller.isEditing.value) {
        _back(result: UpdateResult(UpdateStatus.updated, _controller.todo));
      } else {
        _back(result: UpdateResult(UpdateStatus.created, _controller.todo));
      }
    }
  }

  void _back(
      {UpdateResult result = const UpdateResult(UpdateStatus.none, null)}) {
    Get.back(result: result);
  }
}

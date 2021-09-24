import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/todo_detail_controller.dart';

const priorityMap = {1: 'Low', 2: 'Medium', 3: 'High'};

const menuSave = 'Save and Back';
const menuDelete = 'Delete';

class TodoDetail extends StatelessWidget {
  final TodoDetailController _controller = Get.find();

  final _actionChoices = [menuSave, menuDelete];

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline6;

    return Form(
        key: _controller.formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_controller.pageTitle.value),
            actions: <Widget>[
              PopupMenuButton(
                  onSelected: _selectAction,
                  itemBuilder: (BuildContext context) => _actionChoices
                      .map((String choice) => PopupMenuItem<String>(
                          value: choice, child: Text(choice)))
                      .toList())
            ],
          ),
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
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(10),
                          child: TextButton.icon(
                            icon: Icon(Icons.chevron_left),
                            onPressed: () {
                              _back();
                            },
                            label: Text('Back'),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              _save();
                            },
                            label: Text('Save'),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(10),
                          child: TextButton.icon(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _delete();
                            },
                            label: Text('Delete'),
                            style: TextButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        )),
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
      case menuSave:
        _save();
        break;
      default:
    }
  }

  void _delete() async {
    await _controller.deleteTodo();
    _back(updated: true);
  }

  void _save() async {
    if (_controller.formKey.currentState!.validate()) {
      _controller.saveTodo();
      _back(updated: true);
    }
  }

  void _back({bool updated = false}) {
    Get.back(result: updated);
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/util/dbhelper.dart';

final dbHelper = DbHelper();
const priorityMap = {1: 'Low', 2: 'Medium', 3: 'High'};

const menuSave = 'Save and Back';
const menuDelete = 'Delete';
const menuBack = 'Back';

class TodoDetail extends StatefulWidget {
  final Todo _todo;

  TodoDetail(this._todo);

  @override
  State<StatefulWidget> createState() => _TodoDetailState(_todo);
}

class _TodoDetailState extends State {
  var _priority;
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  Todo _todo;

  _TodoDetailState(this._todo);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _priority = this._todo.id != null ? _todo.priority : 1;
    _todo.priority = _priority;

    _titleController.text = _todo.title;
    _descriptionController.text = _todo.description ??= '';

    _titleController.addListener(() {
      _todo.title = _titleController.text;
    });

    _descriptionController.addListener(() {
      _todo.description = _descriptionController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline6;
    var actionChoices = [menuSave, menuDelete, menuBack];

    if (_todo.id == null) {
      actionChoices = [menuSave, menuBack];
    }

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(_todo.title.isEmpty ? 'Create Todo' : _todo.title),
            actions: <Widget>[
              PopupMenuButton(
                  onSelected: _selectAction,
                  itemBuilder: (BuildContext context) => actionChoices
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
                    controller: _titleController,
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
                      controller: _descriptionController,
                      style: textStyle,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  ListTile(
                    title: DropdownButton<String>(
                      items: priorityMap.entries
                          .map((p) => DropdownMenuItem<String>(
                                child: Text(p.value),
                                value: p.key.toString(),
                              ))
                          .toList(),
                      style: textStyle,
                      value: _priority.toString(),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _priority = int.parse(value);
                            _todo.priority = _priority;
                          });
                        }
                      },
                    ),
                  )
                ],
              )
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _selectAction(String value) {
    switch (value) {
      case menuBack:
        _back();
        break;
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
    var result = await dbHelper.deleteTodo(_todo.id!);
    _back();

    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Delete TODO'),
        content: Text('The TODO has been deleted'),
      );

      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _todo.date = DateFormat.yMd().format(DateTime.now());

      if (_todo.id == null) {
        await dbHelper.insertTodo(_todo);
      } else {
        await dbHelper.updateTodo(_todo);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Todo '${_todo.title}' Saved"),
        duration: const Duration(seconds: 3),
      ));
      _back();
    }
  }

  void _back() {
    Navigator.pop(context, true);
  }
}

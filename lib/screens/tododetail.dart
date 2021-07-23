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

    setState(() {
      if (this._todo.id != null) {
        _priority = _todo.priority;
      } else {
        _priority = 1;
        _todo.priority = _priority;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = _todo.title;
    _descriptionController.text = _todo.description ??= '';
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
            title: Text(_todo.title),
            actions: <Widget>[
              PopupMenuButton(
                  onSelected: selectAction,
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
                    onChanged: (_) => _todo.title = _titleController.text,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: TextField(
                      controller: _descriptionController,
                      style: textStyle,
                      onChanged: (_) =>
                          _todo.description = _descriptionController.text,
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

  void selectAction(String value) {
    switch (value) {
      case menuBack:
        back();
        break;
      case menuDelete:
        delete();
        break;
      case menuSave:
        save();
        break;
      default:
    }
  }

  void delete() async {
    var result = await dbHelper.deleteTodo(_todo.id!);
    back();

    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text('Delete TODO'),
        content: Text('The TODO has been deleted'),
      );

      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void save() async {
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
      back();
    }
  }

  void back() {
    Navigator.pop(context, true);
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todos/src/database/database.dart';

const priorityMap = {1: 'Low', 2: 'Medium', 3: 'High'};

const menuSave = 'Save and Back';
const menuDelete = 'Delete';
const menuBack = 'Back';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

class TodoDetail extends StatefulWidget {
  final Todo? _todo;

  TodoDetail(this._todo);

  @override
  State<StatefulWidget> createState() => _TodoDetailState(_todo);
}

class _TodoDetailState extends State {
  var _priority;
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _actionChoices = [menuSave, menuDelete, menuBack];
  var _pageTitle;

  final TodosDatabase _db;

  Todo? _todo;

  _TodoDetailState(this._todo): this._db = getIt<TodosDatabase>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _priority = _todo?.priority ?? 1;
    _titleController.text = _todo?.title ?? '';
    _descriptionController.text = _todo?.description ?? '';
    _pageTitle = _todo?.title ?? 'Create a todo';

    if (_todo == null) {
      _actionChoices = [menuSave, menuBack];
    }

    _titleController.addListener(() {
      _pageTitle = _titleController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline6;

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(_pageTitle),
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
    var result = await _db.deleteTodo(this._todo!);
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
      var now = DateTime.now().toUtc();

      if (_todo == null) {
        var todo = TodosCompanion.insert(
              title: _titleController.text,
              priority: _priority,
              createdAt: now,
              updatedAt: now
        );

        await _db.addTodo(todo);
      } else {
        Todo todo = _todo!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          updatedAt: now
        );

        await _db.updateTodo(todo);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Todo '${_titleController.text}' Saved"),
        duration: const Duration(seconds: 3),
      ));
      _back();
    }
  }

  void _back() {
    Navigator.pop(context, true);
  }
}

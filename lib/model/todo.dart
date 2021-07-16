class Todo {
  int? _id;
  String _title;
  String? _description;
  String _date;
  int _priority;

  Todo(this._title, this._priority, this._date, [this._description]);

  Todo.empty() : this('', 3, '');

  Todo.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int get priority => _priority;

  String get date => _date;

  String? get description => _description;

  String get title => _title;

  int? get id => _id;

  set priority(int priority) {
    if (priority > 0 && priority <= 3) {
      _priority = priority;
    }
  }

  set date(String value) {
    _date = value;
  }

  set description(String? description) {
    if (description == null || description.length <= 255) {
      _description = description;
    }
  }

  set title(String title) {
    if (title.length <= 255) {
      _title = title;
    }
  }

  set id(int? value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  factory Todo.fromObject(dynamic obj) {
    return Todo.withId(obj["id"], obj["title"], obj["priority"], obj["date"],
        obj["description"]);
  }
}

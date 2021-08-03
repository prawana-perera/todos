class Todo {
  int? _id;
  String title;
  String? description;
  String date;
  int priority;

  Todo(this.title, this.priority, this.date, [this.description]);

  Todo.empty() : this('', 3, '');

  Todo.withId(this._id, this.title, this.priority, this.date,
      [this.description]);

  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["description"] = description;
    map["priority"] = priority;
    map["date"] = date;

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

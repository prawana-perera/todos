import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(explicitToJson: true)
class Todo {
  String? id;
  String name;
  String? description;
  int priority;
  String? owner;

  Todo(this.id, this.name, this.description, this.priority, {this.owner});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

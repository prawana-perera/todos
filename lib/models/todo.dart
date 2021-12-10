import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(explicitToJson: true)
class Todo {
  String? id;
  String title;
  String? description;
  String priority;
  String? owner;

  Todo(this.id, this.title, this.description, this.priority, {this.owner});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

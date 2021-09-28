import 'package:todos/src/database/database.dart';

enum UpdateStatus { deleted, updated, created, none }

class UpdateResult {
  final UpdateStatus status;
  final Todo? todo;

  const UpdateResult(this.status, this.todo);
}
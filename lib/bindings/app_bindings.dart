import 'package:get/instance_manager.dart';
import 'package:todos/controllers/auth_controller.dart';
import 'package:todos/repositories/amplify_auth_repository.dart';
import 'package:todos/repositories/amplify_todo_repository.dart';
import 'package:todos/repositories/auth_repository.dart';
import 'package:todos/repositories/todo_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<TodoRepository>(AmplifyTodoRepository(), permanent: true);
    Get.put<AuthRepository>(AmplifyAuthRepository(), permanent: true);
    Get.put<AuthController>(AuthController());
  }
}

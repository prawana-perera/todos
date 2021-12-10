import 'package:get/get.dart';
import 'package:todos/controllers/login_controller.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  }
}

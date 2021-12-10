import 'package:get/get.dart';
import 'package:todos/controllers/signup_confirmation_controller.dart';

class SignUpConfirmationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpConfirmationController>(
        () => SignUpConfirmationController());
  }
}

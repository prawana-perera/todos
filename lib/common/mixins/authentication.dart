import 'package:get/get.dart';
import 'package:todos/models/user.dart';
import 'package:todos/services/auth_service.dart';

mixin Authentication on GetxController {
  final _authService = Get.find<AuthService>();

  Future<void> logOut() async {
    await _authService.logOut();
    Get.offAllNamed('/login');
  }

  User? get user {
    return _authService.loggedInUser.value;
  }
}

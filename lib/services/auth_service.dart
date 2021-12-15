import 'package:get/get.dart';
import 'package:todos/models/login_result.dart';
import 'package:todos/models/user.dart';
import 'package:todos/repositories/auth_repository.dart';

class AuthService extends GetxService {
  final _authRepository = Get.find<AuthRepository>();

  var _isLoggedIn = false.obs;
  var isError = false.obs;
  var loggedInUser = Rx<User?>(null);

  bool get isLoggedIn=> _isLoggedIn.value;

  Future<LoginResult> logIn(String username, String password) async {
    final loginResult = await _authRepository.logIn(username, password);

    if (loginResult.status == LoginStatus.success) {
      _isLoggedIn.value = true;
      loggedInUser.value = loginResult.user;
    }

    return loginResult;
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
    loggedInUser.value = null;
    _isLoggedIn.value = false;
  }

  Future<void> checkUserLoggedIn() async {
    if (!isLoggedIn) {
      try {
        final user = await _authRepository.getLoggedInUser();
        loggedInUser.value = user;
        _isLoggedIn.value = user != null;
      } catch (e) {
        print('AppController._checkAuthenticated: $e');
        isError.value = true;
        throw e;
      }
    }
  }
}

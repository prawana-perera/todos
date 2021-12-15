import 'package:get/get.dart';
import 'package:todos/models/login_result.dart';
import 'package:todos/models/user.dart';
import 'package:todos/repositories/auth_repository.dart';

class AuthService extends GetxService {
  final _authRepository = Get.find<AuthRepository>();

  var isLoggedIn = false.obs;
  var isError = false.obs;
  var loggedInUser = Rx<User?>(null);

  // @override
  // void onInit() {
  //   ever(isLoggedIn, _handleAuthChanged);
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   checkUserLoggedIn();
  //   super.onReady();
  // }

  Future<LoginResult> logIn(String username, String password) async {
    final loginResult = await _authRepository.logIn(username, password);

    if (loginResult.status == LoginStatus.success) {
      isLoggedIn.value = true;
      loggedInUser.value = loginResult.user;
    }

    return loginResult;
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
    loggedInUser.value = null;
    isLoggedIn.value = false;
  }

  /*
      TODO: rather than doing the redirect here, maybe client code should register a call back to invoke when auth status changes
  */
  // _handleAuthChanged(isSignedIn) {
  //   if (!isSignedIn) {
  //     Get.offAllNamed('/login');
  //   } else {
  //     Get.offAllNamed('/todos');
  //   }
  // }

  Future<void> checkUserLoggedIn() async {
    if (!isLoggedIn.value) {
      try {
        final user = await _authRepository.getLoggedInUser();
        loggedInUser.value = user;
        isLoggedIn.value = user != null;
      } catch (e) {
        print('AppController._checkAuthenticated: $e');
        isError.value = true;
        throw e;
      }
    }
  }
}

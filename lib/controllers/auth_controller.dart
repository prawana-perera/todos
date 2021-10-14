import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:get/get.dart';
import 'package:todos/models/user.dart';
import 'package:todos/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var isInavalidUser = false.obs;
  var isError = false.obs;
  var loggedInUser = Rx<User?>(null);

  @override
  void onReady() {
    _checkAuthenticated();
    ever(isLoggedIn, _handleAuthChanged);
    super.onReady();
  }

  Future<void> logIn(String username, String password) async {
    try {
      isLoading.value = true;
      isInavalidUser.value = false;
      await Future.delayed(const Duration(seconds: 5));
      final user = await _authRepository.logIn(username, password);
      loggedInUser.value = user;
      isLoggedIn.value = user != null;
    } on NotAuthorizedException {
      isInavalidUser.value = true;
    } catch (e) {
      print('AppController.logIn: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void logOut() async {
    try {
      isLoading.value = true;
      await _authRepository.logOut();
      loggedInUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      print('AppController.logIn: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  _handleAuthChanged(isSignedIn) {
    if (!isSignedIn) {
      Get.offAllNamed("/login");
    } else {
      Get.offAllNamed("/todos");
    }
  }

  void _checkAuthenticated() async {
    try {
      isLoading.value = true;
      final user = await _authRepository.getLoggedInUser();
      await Future.delayed(const Duration(seconds: 5));
      loggedInUser.value = user;
      isLoggedIn.value = user != null;
    } catch (e) {
      print('AppController._checkAuthenticated: $e');
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}

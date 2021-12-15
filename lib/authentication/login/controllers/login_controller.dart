import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:todos/models/login_result.dart';
import 'package:todos/services/auth_service.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormBuilderState>();

  var _isLoading = true.obs;
  var _showPassword = false.obs;
  var _isError = false.obs;
  var _errorMsg = ''.obs;

  bool get isLoading => _isLoading.value;

  bool get showPassword => _showPassword.value;

  bool get isError => _isError.value;

  String get errorMsg => _errorMsg.value;

  @override
  void onReady() async {
    super.onReady();

    await _authService.checkUserLoggedIn();

    if (_authService.isLoggedIn) {
      Get.offAllNamed('/todos');
      return;
    }

    _isLoading.value = false;

    final signUpComplete =
        (Get.parameters['signUpComplete'] ?? 'false') == 'true';

    if (signUpComplete) {
      final email = Get.parameters['email'];
      Get.showSnackbar(
        GetSnackBar(
          messageText: Text(
              'Account $email was created successfully, please login.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18)),
          isDismissible: true,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> logIn() async {
    if (formKey.currentState!.validate()) {
      _isLoading.value = true;
      _errorMsg.value = '';
      _isError.value = false;

      final username = formKey.currentState?.fields['username']?.value!;
      final password = formKey.currentState?.fields['password']?.value!;

      var loginResult = await _authService.logIn(username, password);

      _isLoading.value = false;

      switch (loginResult.status) {
        case LoginStatus.notAuthorised:
          _isError.value = true;
          _errorMsg.value = 'Invalid username or password.';
          break;
        case LoginStatus.error:
          _isError.value = true;
          _errorMsg.value = 'An error occurred. Please try again later.';
          break;
        case LoginStatus.unconfirmed:
          await Get.offNamed('/signup/confirm',
              parameters: {'email': username, 'isUnconfirmed': 'true'});
          break;
        case LoginStatus.success:
          await Get.offAllNamed('/todos');
          break;
      }
    }
  }

  void toggleShowPassword() {
    _showPassword.toggle();
  }
}

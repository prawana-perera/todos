import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/models/login_result.dart';

import '../services/auth_service.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = true.obs;
  var isInvalidUser = false.obs;
  var isError = false.obs;

  var validators = {
    'username': (String? value) {
      if (value == null || value.trim().length == 0) {
        return 'Please enter a username';
      }

      if (!GetUtils.isEmail(value)) {
        return 'Username should be a valid email address';
      }

      return null;
    },
    'password': (String? value) {
      if (value == null || value.trim().length == 0) {
        return 'Please enter a password';
      }

      if (!GetUtils.isLengthBetween(value, 8, 16)) {
        return 'Password should be between 8 and 16 characters';
      }

      return null;
    },
  };

  @override
  void onReady() async {
    super.onReady();

    await _authService.checkUserLoggedIn();

    if (_authService.isLoggedIn.value) {
      Get.offAllNamed('/todos');
      return;
    }

    isLoading.value = false;

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

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> logIn() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      isInvalidUser.value = false;
      isError.value = false;

      var loginResult = await _authService.logIn(
          usernameController.text, passwordController.text);

      switch (loginResult.status) {
        case LoginStatus.notAuthorised:
          isInvalidUser.value = true;
          isLoading.value = false;
          break;
        case LoginStatus.error:
          isError.value = true;
          isLoading.value = false;
          break;
        case LoginStatus.unconfirmed:
          await Get.offNamed('/signup/confirm', parameters: {
            'email': usernameController.text,
            'isUnconfirmed': 'true'
          });
          break;
        case LoginStatus.success:
          await Get.offAllNamed('/todos');
          break;
      }
    }
  }
}

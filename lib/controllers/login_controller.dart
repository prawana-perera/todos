import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginController extends GetxController {
  final _authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

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

  Rx<bool> get isLoading {
    return _authController.isLoading;
  }

  Rx<bool> get isInavalidUser {
    return _authController.isInavalidUser;
  }

  void logIn() async {
    if (formKey.currentState!.validate()) {
      Get.dialog(WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
      ));

      // Clear cached login
      await _authController.logOut();
      await _authController.logIn(
          usernameController.text, passwordController.text);

      Get.back();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}

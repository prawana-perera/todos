import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/models/signup.dart';
import 'package:todos/models/signup_result.dart';
import 'package:todos/repositories/auth_repository.dart';

class SignUpController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final isLoading = false.obs;
  final isError = false.obs;
  final errorMsg = ''.obs;

  var validators;

  SignUpController() {
    validators = {
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
      'confirmPassword': (String? value) {
        if (value == null || value.trim().length == 0) {
          return 'Please confirm your password';
        }

        if (passwordController.text != value) {
          return 'Password confirmation does not match';
        }

        return null;
      },
      'name': (String? value) {
        if (value == null || value.trim().length == 0) {
          return 'Please enter your name';
        }

        return null;
      },
    };
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      isError.value = false;

      Get.dialog(WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
      ));

      final result = await _authRepository.signUp(SignUp(
          usernameController.text,
          passwordController.text,
          nameController.text));

      Get.back();

      isLoading.value = false;

      switch (result.status) {
        case SignUpStatus.duplicateUser:
          isError.value = true;
          errorMsg.value = 'Username/email already exists';
          isLoading.value = false;
          break;
        case SignUpStatus.invalidPassword:
          isError.value = true;
          errorMsg.value =
              'Your password must contain x chars/symbols etc etc.';
          isLoading.value = false;
          break;
        case SignUpStatus.error:
          isError.value = true;
          errorMsg.value = 'An error occurred. Please try again later.';
          isLoading.value = false;
          break;
        case SignUpStatus.success:
          isError.value = false;
          errorMsg.value = '';
          await Get.offNamed('/signup/confirm',
              parameters: {'email': usernameController.text});
          break;
      }
    }
  }
}

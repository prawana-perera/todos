import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/models/signup_confirmation_result.dart';
import 'package:todos/repositories/auth_repository.dart';

class SignUpConfirmationController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  final formKey = GlobalKey<FormState>();
  final confirmCodeController = TextEditingController();

  var isLoading = false.obs;
  var isInvalidCode = false.obs;
  var isError = false.obs;

  var validators = {
    'confirmCode': (String? value) {
      if (value == null || value.trim().length == 0) {
        return 'Please enter the confirmation code';
      }

      return null;
    },
  };

  @override
  void onReady() {
    final email = Get.parameters['email']!;
    final isUnconfirmed =
        (Get.parameters['isUnconfirmed'] ?? 'false') == 'true';
    final message = isUnconfirmed
        ? 'Please enter code sent to $email before logging in.'
        : 'A confirmation code was sent to $email.';

    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(message,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14)),
        isDismissible: true,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> confirm() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      Get.dialog(WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
        ),
      ));

      final email = Get.parameters['email']!;
      final result = await _authRepository.confirmSignUp(
          email, confirmCodeController.text);

      Get.back();

      switch (result.status) {
        case SignupConfirmationStatus.invalidCode:
          isInvalidCode.value = true;
          isError.value = false;
          isLoading.value = false;
          break;
        case SignupConfirmationStatus.error:
          isInvalidCode.value = false;
          isError.value = true;
          isLoading.value = false;
          break;
        case SignupConfirmationStatus.success:
          await Get.offNamed('/login',
              parameters: {'email': email, 'signUpComplete': 'true'});
          break;
      }
    }
  }

  Future<void> resendSignUpCode() async {
    isLoading.value = true;

    Get.dialog(WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
    ));

    final email = Get.parameters['email']!;
    await _authRepository.resendSignUpCode(email);

    Get.back();

    Get.showSnackbar(
      GetSnackBar(
        messageText: Text('A new confirmation code was sent to $email.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14)),
        isDismissible: true,
        duration: Duration(seconds: 3),
      ),
    );

    isLoading.value = false;
  }
}

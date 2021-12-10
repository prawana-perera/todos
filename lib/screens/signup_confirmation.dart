import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/signup_confirmation_controller.dart';

class SignUpConfirmation extends StatelessWidget {
  final _signupController = Get.find<SignUpConfirmationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
              title: Text('Confirm email'),
              leading: IconButton(
                  onPressed: _signupController.isLoading.value
                      ? null
                      : () => Get.offNamed('/login'),
                  icon: Icon(Icons.arrow_back))),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: AssetImage('assets/images/todos_sign_up.png'),
                          fit: BoxFit.scaleDown)),
                  // height: Get.height,
                  width: double.infinity,
                  child: Form(
                    key: _signupController.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Account Confirmation",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Enter the confirmation code",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  validator: _signupController
                                      .validators['confirmCode'],
                                  controller:
                                      _signupController.confirmCodeController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      labelText: 'Confirmation code',
                                      hintText: 'Check your email')),
                            ),
                            Visibility(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'An error occurred. Please try again later.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              visible: _signupController.isError.value,
                            ),
                            Visibility(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'Invalid confirmation code.',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              visible: _signupController.isInvalidCode.value,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.check),
                                        onPressed:
                                            _signupController.isLoading.value
                                                ? null
                                                : _signupController.confirm,
                                        label: Text('Confirm'),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 15),
                                          textStyle: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        _signupController.resendSignUpCode(),
                                    child: Text(
                                      "Resend confirmation code",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}

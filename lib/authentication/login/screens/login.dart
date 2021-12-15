import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:todos/authentication/login/controllers/login_controller.dart';
import 'package:todos/screens/loading.dart';

class Login extends StatelessWidget {
  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _loginController.isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Please Login'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: FormBuilder(
                    key: _loginController.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Welcome to your Todos'),
                          subtitle: Text(
                            'A place to organise your life. Please login to start.',
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Image.asset('assets/images/login.png'),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: FormBuilderTextField(
                            name: 'username',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                              labelText: 'User Name',
                              hintText: 'Enter valid mail e.g. abc@gmail.com',
                            ),
                            enabled: !_loginController.isLoading,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context, errorText: 'Please enter your username'),
                              FormBuilderValidators.email(context, errorText: 'Username must be a valid email address'),
                              FormBuilderValidators.max(context, 320, errorText: 'Username must be less than 320 characters'),
                            ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                          child: FormBuilderTextField(
                              name: 'password',
                              enabled: !_loginController.isLoading,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context, errorText: 'Please enter your password'),
                                FormBuilderValidators.min(context, 8, errorText: 'Password should be between 8 and 16 characters'),
                                FormBuilderValidators.max(context, 16, errorText: 'Password should be between 8 and 16 characters'),
                              ]),
                              obscureText: !_loginController.showPassword,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  suffixIcon: IconButton(
                                    onPressed: () => _loginController.toggleShowPassword(),
                                    icon: Icon(_loginController.showPassword ? Icons.visibility_off : Icons.visibility),
                                  ))),
                        ),
                        Visibility(
                            child: Text(
                              _loginController.errorMsg,
                              style: TextStyle(color: Colors.red),
                            ),
                            visible: _loginController.isError),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.login),
                                    onPressed: _loginController.isLoading ? null : _loginController.logIn,
                                    label: Text('Login'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                      textStyle: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.person_add),
                                    onPressed: _loginController.isLoading ? null : () => Get.offNamed('/signup'),
                                    label: Text('Create Account'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blueGrey,
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                      textStyle: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

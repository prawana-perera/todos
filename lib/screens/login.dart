import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/login_controller.dart';

class Login extends StatelessWidget {
  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please Login'),
      ),
      body: SingleChildScrollView(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Obx(() => Form(
                key: _loginController.formKey,
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
                      child: TextFormField(
                          enabled: !_loginController.isLoading.value,
                          controller: _loginController.usernameController,
                          validator: _loginController.validators['username'],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelText: 'User Name',
                              hintText: 'Enter valid mail e.g. abc@gmail.com')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                          enabled: !_loginController.isLoading.value,
                          controller: _loginController.passwordController,
                          validator: _loginController.validators['password'],
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              labelText: 'Password',
                              hintText: 'Enter your password')),
                    ),
                    Visibility(
                      child: Text(
                        'Inavalid username or password',
                        style: TextStyle(color: Colors.red),
                      ),
                      visible: _loginController.isInavalidUser.value,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.login),
                                onPressed: _loginController.isLoading.value
                                    ? null
                                    : () => _loginController.logIn(),
                                label: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
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
                              padding:
                                  EdgeInsets.only(top: 15, left: 10, right: 10),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.person_add),
                                onPressed: _loginController.isLoading.value
                                    ? null
                                    : () async => await Get.toNamed('/signup'),
                                label: Text('Create Account'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  textStyle: TextStyle(fontSize: 20),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

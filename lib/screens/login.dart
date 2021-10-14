import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/controllers/auth_controller.dart';

class Login extends StatelessWidget {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please Login'),
      ),
      body: SingleChildScrollView(
        child: Card(
          clipBehavior: Clip.antiAlias,
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
                    enabled: !_authController.isLoading.value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        labelText: 'User Name',
                        hintText: 'Enter valid mail e.g. abc@gmail.com')),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                child: TextFormField(
                    enabled: !_authController.isLoading.value,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        labelText: 'Password',
                        hintText: 'Enter your password')),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    onPressed: _authController.isLoading.value
                        ? null
                        : () {
                            _authController.logIn(
                                'prawana.perera@gmail.com', 'TBA');
                          },
                    label: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

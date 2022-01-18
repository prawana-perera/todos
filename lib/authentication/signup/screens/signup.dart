import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/authentication/signup/controllers/signup_controller.dart';

class SignUp extends StatelessWidget {
  final _signupController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text('Create an account'),
            leading: IconButton(
                onPressed: _signupController.isLoading.value ? null : () => Get.offNamed('/login'), icon: Icon(Icons.arrow_back)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
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
                                  "Sign up for Todos",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Create an account, to start todo-ing!",
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
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  validator: _signupController.validators['username'],
                                  controller: _signupController.usernameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                      labelText: 'Email',
                                      hintText: 'Enter valid email e.g. abc@abc.com')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  validator: _signupController.validators['password'],
                                  controller: _signupController.passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                      labelText: 'Password (8-16)',
                                      hintText: 'Password (8-16)')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  validator: _signupController.validators['confirmPassword'],
                                  controller: _signupController.confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                      labelText: 'Confirm Password',
                                      hintText: 'Password (8-16)')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  validator: _signupController.validators['name'],
                                  controller: _signupController.nameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                      labelText: 'Name',
                                      hintText: 'Your full name')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                      labelText: 'Phonenumber',
                                      hintText: 'Your phone number with area code')),
                            ),
                            Visibility(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
                                  _signupController.errorMsg.value,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              visible: _signupController.isError.value,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.add_circle),
                                        onPressed: _signupController.isLoading.value ? null : _signUp,
                                        label: Text('SignUp'),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                          textStyle: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already signed up? "),
                                  InkWell(
                                    onTap: () => Get.offNamed('/login'),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue),
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

  _signUp() async {
    await _signupController.signUp();
  }
}

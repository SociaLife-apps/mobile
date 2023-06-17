// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:socialife_mobile/controllers/login_controller.dart';
import 'package:socialife_mobile/controllers/registration_controller.dart';
import 'package:socialife_mobile/screens/auth/widgets/input_fields.dart';
import 'package:socialife_mobile/screens/auth/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  RegistrationController registrationController =
      Get.put(RegistrationController());

  LoginController loginController = Get.put(LoginController());

  var isLogin = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Center(
            child: Obx(
              () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/socialife_logo.png', // Replace with your image asset path
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: !isLogin.value ? Colors.white : Colors.purple.shade400,
                          onPressed: () {
                            isLogin.value = false;
                          },
                          child: Text('Register'),
                        ),
                        MaterialButton(
                          color: isLogin.value ? Colors.white : Colors.purple.shade400,
                          onPressed: () {
                            isLogin.value = true;
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    isLogin.value ? loginWidget() : registerWidget()
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Column(
      children: [
        InputTextFieldWidget(
            registrationController.usernameController, 'Username', false),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registrationController.passwordController, 'Password', true),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registrationController.confirmPassController, 'Confirm Password', true),
        SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => registrationController.register(),
          title: 'Register',
        )
      ],
    );
  }

  Widget loginWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(loginController.usernameController, 'Username', false),
        SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(loginController.passwordController, 'Password', true),
        SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => loginController.login(),
          title: 'Login',
        )
      ],
    );
  }
}

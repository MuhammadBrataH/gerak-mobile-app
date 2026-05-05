import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(label: Text('Email')),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(label: Text('Password')),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        // Call the login method with dummy credentials
                        controller.login(emailController.text, passwordController.text);
                      },

                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

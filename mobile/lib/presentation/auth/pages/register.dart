import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/pages/bottom_bar.dart';
import 'package:isentry/presentation/widgets/forms/auth_text_field.dart';
import 'package:isentry/presentation/widgets/buttons/auth_button.dart';
import 'package:isentry/presentation/widgets/typography/auth_heading.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeading(
                  title1: 'Hello!',
                  title2: 'Register to get started',
                ),
                CustomTextField(
                  hintText: 'Full name',
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  buttonText: 'Register',
                  Backcolor: const Color(0xFF18181B),
                  TextColor: Colors.white,
                  onPressed: () async {
                    var url = Uri.http(
                        ipAddress, 'api/users'); // change sesuai IP address
                    var response = await http.post(url, body: {
                      'name': fullNameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'role': 'OWNER',
                    });
                    var body = json.decode(response.body);

                    print(body);
                    if (body['success']) {
                      AppNavigator.push(context, const HomePage());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('gagal'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " Login Now",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppNavigator.pushAndRemove(
                            context,
                            const LoginPage(),
                          );
                        },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

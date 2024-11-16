// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/home_resident/pages/bottom_bar_resident.dart';
// import 'package:isentry/presentation/home/pages/bottom_bar.dart';
// import 'package:isentry/presentation/home/pages/dashboard.dart';
import 'package:isentry/presentation/widgets/forms/auth_text_field.dart';
import 'package:isentry/presentation/widgets/buttons/auth_button.dart';
import 'package:isentry/presentation/widgets/typography/auth_heading.dart';
// import 'package:http/http.dart' as http;

class LoginResidentPage extends StatelessWidget {
  const LoginResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Credentials'),
            content: const Text('Please check your email and password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

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
                  title1: 'Welcome back!',
                  title2: 'Glad to see you, Again!',
                ),
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
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      //
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                CustomElevatedButton(
                  buttonText: 'Login',
                  Backcolor: const Color(0xFF18181B),
                  TextColor: Colors.white,
                  onPressed: () {
                    AppNavigator.push(context, const HomeResidentPage());
                    // var url = Uri.http('192.168.1.5:3000',
                    //     'api/auth/login'); // change sesuai IP address
                    // var response = await http.post(url, body: {
                    //   'email': emailController.text,
                    //   'password': passwordController.text,
                    // });
                    // var body = json.decode(response.body);

                    // print(body);
                    // if (body['success']) {
                    //   AppNavigator.push(context, const HomePage());
                    // } else {
                    //   _showMyDialog();
                    // }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

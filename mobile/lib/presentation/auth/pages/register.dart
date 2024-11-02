import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/auth/pages/qr_register.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:isentry/presentation/auth/widget/text_field.dart';
import 'package:isentry/presentation/auth/widget/button.dart';
import 'package:isentry/presentation/auth/widget/heading.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeading(
                title1: 'Hello!',
                title2: 'Register to get started',
              ),
              CustomTextField(
                hintText: 'Enter your full name',
                controller: fullNameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                obscureText: true,
                suffixIcon: const Icon(
                  LucideIcons.eyeOff,
                  color: Colors.grey, // Tambahkan warna abu-abu pada ikon
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: true,
                suffixIcon: const Icon(
                  LucideIcons.eyeOff,
                  color: Colors.grey, // Tambahkan warna abu-abu pada ikon
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                buttonText: 'Register',
                onPressed: () {
                  // Tambahkan logika register di sini
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Or Login with'),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      AppNavigator.pushAndRemove(context,
                          const QrRegisterPage()); // sementara redirect ke halaman QR Register User Resident
                    },
                    icon: const Icon(Icons.qr_code, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      AppNavigator.push(context, const QrRegisterPage());
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      // GitHub login logic di sini
                    },
                    icon: const Icon(Icons.code, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      AppNavigator.pushAndRemove(context, const LoginPage());
                    },
                    child: const Text(
                      'Login Now',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

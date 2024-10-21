import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iSentry/widgets/auth/button.dart';
import 'package:iSentry/widgets/auth/heading.dart';
import 'package:iSentry/widgets/auth/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeading(
                title1: 'Welcome back!',
                title2: 'Glad to see you, Again!',
              ),
              CustomTextField(
                labelText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Enter your password',
                controller: passwordController,
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot Password logic here
                  },
                  child: const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                buttonText: 'Login',
                onPressed: () {
                  // Login logic here
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Or Login with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      // QR code login logic here
                    },
                    icon: const Icon(Icons.qr_code, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      // Google login logic here
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      // GitHub login logic here
                    },
                    icon: const Icon(Icons.code, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: const Text('Register Now', style: TextStyle(color: Colors.grey)),
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

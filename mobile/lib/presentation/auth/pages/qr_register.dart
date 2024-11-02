import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:isentry/presentation/auth/widget/text_field.dart';
import 'package:isentry/presentation/auth/widget/button.dart';
import 'package:isentry/presentation/auth/widget/heading.dart';

class QrRegisterPage extends StatefulWidget {
  const QrRegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QrRegisterPageState createState() => _QrRegisterPageState();
}

class _QrRegisterPageState extends State<QrRegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                keyboardType: TextInputType.text,
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
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: true,
                suffixIcon: const Icon(
                  LucideIcons.eyeOff,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logic untuk scan QR Code
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF3F3F46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.scanFace, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Take a Picture',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              CustomElevatedButton(
                buttonText: 'Register',
                onPressed: () {
                  // Logic untuk registrasi
                  context
                      .go('/'); // Kembali ke halaman utama setelah registrasi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

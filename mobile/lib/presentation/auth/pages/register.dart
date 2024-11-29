import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/pages/bottom_bar.dart';
import 'package:isentry/presentation/widgets/forms/auth_text_field.dart';
import 'package:isentry/presentation/widgets/buttons/auth_button.dart';
import 'package:isentry/presentation/widgets/typography/auth_heading.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            context.read<LoginBloc>().add(
                  LoginSubmitted(
                      username: usernameController.text,
                      password: passwordController.text),
                );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }

          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  userId: state.user.id,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 20, right: 20, bottom: 20),
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
                      hintText: 'Name',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: 'Username',
                      controller: usernameController,
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
                        FocusScope.of(context).unfocus();

                        if (nameController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("data ada yang kosong"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Confirm password salah"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        context.read<LoginBloc>().add(
                              SignupSubmitted(
                                name: nameController.text,
                                username: usernameController.text,
                                password: passwordController.text,
                                role: 'OWNER',
                              ),
                            );
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
          );
        },
      ),
    );
  }
}

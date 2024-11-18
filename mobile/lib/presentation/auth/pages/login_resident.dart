// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/data/models/user_model.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home_resident/pages/bottom_bar_resident.dart';
import 'package:isentry/presentation/widgets/forms/auth_text_field.dart';
import 'package:isentry/presentation/widgets/buttons/auth_button.dart';
import 'package:isentry/presentation/widgets/typography/auth_heading.dart';
import 'package:quickalert/quickalert.dart';

class LoginResidentPage extends StatelessWidget {
  const LoginResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (state.user.role == Role.OWNER) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                title: 'Warning',
                text: 'Maaf anda bukan resident',
              );
              return;
            } else if (state.user.role == Role.RESIDENT) {
              AppNavigator.pushReplacement(context, const HomeResidentPage());
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
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
                      title1: 'Welcome back!',
                      title2: 'Glad to see you, Again!',
                    ),
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
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      buttonText: 'Login',
                      Backcolor: const Color(0xFF18181B),
                      TextColor: Colors.white,
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Username atau password kosong"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        context.read<LoginBloc>().add(
                              LoginSubmitted(
                                username: usernameController.text,
                                password: passwordController.text,
                              ),
                            );
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
                          child: Text('Or'),
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
                    CustomElevatedButton(
                      buttonText: 'Login as Owner',
                      Backcolor: const Color(0xFFf1f4f9),
                      TextColor: Colors.black,
                      border: const BorderSide(color: Colors.black, width: 1),
                      onPressed: () {
                        AppNavigator.pushReplacement(
                            context, const LoginPage());
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

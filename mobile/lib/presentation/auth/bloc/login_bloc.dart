// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:isentry/common/helper/navigation/app_navigation.dart';
// import 'package:isentry/presentation/home/pages/bottom_bar.dart';

// class LoginBloc {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   Future<void> login() async {
//     var url = Uri.http('192.168.18.41:3000', 'api/auth/login');
//     var response = await http.post(url, body: {
//       'email': emailController.text,
//       'password': passwordController.text,
//     });

//     var body = json.decode(response.body);
//     if (body['success']) {
//       AppNavigator.pushAndRemove(context, HomePage());
//     } else {
//       // Show error dialog
//     }
//   }
// }

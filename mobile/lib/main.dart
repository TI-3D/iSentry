import 'package:flutter/material.dart';
import 'package:iSentry/router/routes.dart';
import 'package:iSentry/themes/appTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: getRoute(),
      theme: appTheme,
    );
  }
}

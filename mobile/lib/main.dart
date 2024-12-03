import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/theme/app_theme.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/splash/bloc/splash_cubit.dart';
import 'package:isentry/presentation/splash/pages/splash.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => SplashCubit()..appStarted()),
      BlocProvider(create: (context) => LoginBloc()),
      BlocProvider(create: (context) => UserBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const SplashPage(),
    );
  }
}

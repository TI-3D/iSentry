import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/theme/app_theme.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_bloc.dart';
import 'package:isentry/presentation/home/bloc/medias/media_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/splash/bloc/splash_cubit.dart';
import 'package:isentry/presentation/splash/pages/splash.dart';
import 'package:isentry/services/notification_service.dart';
import 'package:isentry/services/websocket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi notifikasi
  await NotificationService.init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => SplashCubit()..appStarted()),
      BlocProvider(create: (context) => LoginBloc()),
      BlocProvider(create: (context) => UserBloc()),
      BlocProvider(create: (context) => DetectionBloc()),
      BlocProvider(create: (context) => IdentityBloc()),
      BlocProvider(create: (context) => FaceBloc()..add(LoadUnrecognizedFaces())),
      BlocProvider(create: (context) => MediaBloc())
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

    // Inisialisasi WebSocketService
    WebSocketService.connect(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const SplashPage(),
    );
  }
}

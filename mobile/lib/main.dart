import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pbl_op/pages/bottomnav.dart';
import 'package:pbl_op/pages/camera_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const BottomAppBarExample();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/camera',
          builder: (BuildContext context, GoRouterState state) {
            return const CameraPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

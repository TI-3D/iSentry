import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iSentry/pages/auth/login.dart';
import 'package:iSentry/pages/auth/qr_register.dart';
import 'package:iSentry/pages/auth/register.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register', 
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage(); 
      },
    ),
    GoRoute(
      path: '/qr_register',
      builder: (BuildContext context, GoRouterState state) {
        return const QrRegisterPage();
      },
    ),
  ],
);

GoRouter getRoute() => _router;

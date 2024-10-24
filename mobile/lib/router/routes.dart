import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iSentry/pages/auth/login.dart';
import 'package:iSentry/pages/auth/qr_register.dart';
import 'package:iSentry/pages/auth/register.dart';
import 'package:iSentry/pages/auth/account_settings.dart';

final GoRouter _router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage(); // Halaman Login
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage(); // Halaman Register
      },
    ),
    GoRoute(
      path: '/qr_register',
      builder: (BuildContext context, GoRouterState state) {
        return const QrRegisterPage(); // Halaman QR Register
      },
    ),
    GoRoute(
      path: '/account_settings',
      builder: (BuildContext context, GoRouterState state) {
        return const AccountSettingPage(); // Halaman Pengaturan Akun
      },
    ),
  ],
);

GoRouter getRoute() => _router;

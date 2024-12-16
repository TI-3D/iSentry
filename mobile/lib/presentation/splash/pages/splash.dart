import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/assets/app_images.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/pages/bottom_bar.dart';
import 'package:isentry/presentation/home_resident/pages/bottom_bar_resident.dart';
import 'package:isentry/presentation/splash/bloc/splash_cubit.dart';
import 'package:isentry/presentation/splash/bloc/splash_state.dart';
import 'package:isentry/services/network_service.dart';
import 'package:isentry/services/secure_storage_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) async {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, const LoginPage());
          }

          if (state is Authenticated) {
            final token = await SecureStorageService.read("jwt_token");
            final idString = await SecureStorageService.read("id");
            final role = await SecureStorageService.read("role");
            // print("Token: $token");
            // print("ID: $idString");
            // print("Role: $role");
            if (idString != null && token != null) {
              NetworkService.setToken(token);
              final id = int.tryParse(idString);
              if (id != null) {
                if (role == 'OWNER') {
                  AppNavigator.pushReplacement(
                      context, HomePage(userId: idString));
                } else if (role == 'RESIDENT') {
                  AppNavigator.pushReplacement(
                      context, HomeResidentPage(userId: idString));
                } else {
                  AppNavigator.pushReplacement(context, const LoginPage());
                }
              }
            }
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.splashBackground),
            ),
          ),
        ),
      ),
    );
  }
}

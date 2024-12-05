import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/core/configs/assets/app_images.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/pages/bottom_bar.dart';
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
            if (idString != null && token != null) {
              NetworkService.setToken(token);
              final id = int.tryParse(idString);
              if (id != null) {
                AppNavigator.pushReplacement(
                    context, HomePage(userId: idString));
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

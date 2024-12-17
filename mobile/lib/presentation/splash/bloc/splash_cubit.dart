import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/presentation/splash/bloc/splash_state.dart';
import 'package:isentry/services/network_service.dart';
import 'package:isentry/services/secure_storage_service.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    String? token = await SecureStorageService.read("jwt_token");
    String? refreshToken = await SecureStorageService.read("jwt_refresh_token");

    if (token != null && refreshToken != null) {
      try {
        if (await NetworkService.isTokenExpired()) {
          NetworkService.renewToken();
        }
        emit(Authenticated());
      } catch (_) {
        emit(UnAuthenticated());
      }
    } else {
      emit(UnAuthenticated());
    }
  }
}

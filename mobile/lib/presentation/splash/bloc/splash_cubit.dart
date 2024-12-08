import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/presentation/splash/bloc/splash_state.dart';
import 'package:isentry/services/secure_storage_service.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());
  void appStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    String? username = await SecureStorageService.read("username");

    if (username != null) {
      emit(
        Authenticated(),
      );
    } else {
      emit(
        UnAuthenticated(),
      );
    }
  }
}

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/auth/usecase/ensure_valid_token.dart';
import 'package:projectflutter/domain/auth/usecase/is_logged_usecase.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_state.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());
  void appstarted() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future.delayed(const Duration(milliseconds: 100));
    var isLoggedIn = await sl<EnsureValidTokenUsecase>().call();
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    bool? onBoardingDone = prefs.getBool('onboarding_done');
    if (isLoggedIn == true) {
      sl<ExerciseScheduleCubit>()..loadScheduleandNotification();
      emit(Authenticated());
    } else {
      if (onBoardingDone == true) {
        emit(SkipOnBoarding());
      } else {
        emit(UnAuthenticated());
      }
    }
  }
}

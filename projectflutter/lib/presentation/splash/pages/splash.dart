import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';
import 'package:projectflutter/presentation/bmi/pages/check_bmi.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_cubit.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_state.dart';
import 'package:projectflutter/presentation/splash/pages/on_boarding_page_1.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushReplacement(context, const OnBoardingPage1());
        }
        if (state is SkipOnBoarding) {
          AppNavigator.pushReplacement(context, const SigninPage());
        }
        if (state is Authenticated) {
          AppNavigator.pushReplacement(context, const CheckBmiPage());
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: AppColors.primaryG,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          // color: AppColors.primary,
          child: const Center(
            child: Image(
              image: AssetImage(AppImages.imgSplash),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

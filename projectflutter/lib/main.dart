import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_theme.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_cubit.dart';
import 'package:projectflutter/presentation/splash/pages/splash.dart';
import 'package:projectflutter/service_locator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('token');
  // await prefs.remove('id');
  // await prefs.remove('bmi_exist');
  // await prefs.remove('onboarding_done');
  // final bmiLatest = prefs.getString('bmi_latest');
  // if (bmiLatest != null && bmiLatest.isNotEmpty) {
  //   await prefs.remove('bmi_latest');
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appstarted(),
      child: MaterialApp(
          theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkThem,
          // themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const SplashPage()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:projectflutter/core/config/themes/app_theme.dart';
import 'package:projectflutter/domain/exercise/usecase/schedule_exercise.dart';
import 'package:projectflutter/notification_service.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_cubit.dart';
import 'package:projectflutter/presentation/splash/pages/splash.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  await NotificationService.initialize();
  final notificationService = NotificationService();
  await notificationService.requestNotificationPermission();
  await notificationService.checkExactAlarmPermission();

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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ScheduleExerciseUseCase>(
          create: (context) => sl<ScheduleExerciseUseCase>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SplashCubit()..appstarted(),
          ),
          BlocProvider.value(
            value: sl<ExerciseScheduleCubit>()..loadScheduleandNotification(),
          ),
          BlocProvider(
            create: (context) => ButtonExerciseCubit(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ),
      ),
    );
  }
}

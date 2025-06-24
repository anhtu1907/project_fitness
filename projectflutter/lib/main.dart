import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'export.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await SharedPreferenceService.init();
  await initializeDependencies();
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  await NotificationService.initialize();
  final notificationService = NotificationService();
  await notificationService.requestNotificationPermission();
  final hasExactAlarmPermission =
      await notificationService.checkExactAlarmPermission();
  if (!hasExactAlarmPermission) {
    await notificationService.requestExactAlarmPermission();
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // await prefs.remove('onboarding_done');

  // final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('token');
  // await prefs.remove('userId');
  // await prefs.remove('bmi_exist');
  // await prefs.remove('goal_exist');
  // final bmiGoalLatest = prefs.getString('goal_latest');
  // if (bmiGoalLatest != null && bmiGoalLatest.isNotEmpty) {
  //   await prefs.remove('goal_latest');
  // }
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
          // darkTheme: AppTheme.darkThem,
          // themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ),
      ),
    );
  }
}

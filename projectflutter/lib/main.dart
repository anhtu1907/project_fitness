import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:projectflutter/core/config/themes/app_theme.dart';
import 'package:projectflutter/domain/exercise/usecase/schedule_exercise.dart';
import 'package:projectflutter/notification_service.dart';
import 'package:projectflutter/presentation/splash/bloc/splash_cubit.dart';
import 'package:projectflutter/presentation/splash/pages/splash.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  final byteData = await rootBundle.load('assets/timezone/latest.tzf');
  tz.initializeDatabase(byteData.buffer.asUint8List());
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  print('TimeZone name: $timeZoneName');
  print('TZ local location: ${tz.local.name}');
  await NotificationService.initialize();
  final notificationService = NotificationService();

  // 1. Kiểm tra và yêu cầu quyền Notification (Android 13+)
  if (Platform.isAndroid) {
    final hasNotificationPermission =
        await notificationService.requestNotificationPermission();
    if (!hasNotificationPermission) {
      print(
          'Không có quyền notification, người dùng có thể không nhận được thông báo.');
    }
  }

  // 2. Kiểm tra và yêu cầu quyền exact alarm (Android 12+)
  if (Platform.isAndroid) {
    final hasExactAlarmPermission =
        await notificationService.checkExactAlarmPermission();
    print('Exact alarm permission: $hasExactAlarmPermission');
    if (!hasExactAlarmPermission) {
      print('Chưa có quyền exact alarm, mở cài đặt cho người dùng');
      await notificationService.requestExactAlarmPermission();
    }
  }
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
        // Bạn có thể add thêm các use case khác tại đây
      ],
      child: BlocProvider(
        create: (context) => SplashCubit()..appstarted(),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashPage(),
        ),
      ),
    );
  }
}

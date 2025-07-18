import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/schedule_exercise.dart';
import 'package:projectflutter/notification_service.dart';

class SelectDateSchedule extends StatefulWidget {
  final String icon;
  final String title;
  final Color color;
  final int subCategoryId;
  const SelectDateSchedule(
      {super.key,
      required this.icon,
      required this.title,
      required this.color,
      required this.subCategoryId});

  @override
  State<SelectDateSchedule> createState() => _SelectDateScheduleState();
}

class _SelectDateScheduleState extends State<SelectDateSchedule> {
  String selectedDateTime = 'Select Date';

  void _pickDateTime(BuildContext context) async {
    final notificationService = NotificationService();
    bool hasPermission =
        await notificationService.requestNotificationPermission();

    if (!hasPermission) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
              'The app requires notification permission to send workout reminders. Please enable notification permission in the settings.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (Platform.isAndroid) {
                  final packageInfo = await PackageInfo.fromPlatform();
                  final intent = AndroidIntent(
                    action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                    arguments: <String, dynamic>{
                      'android.provider.extra.APP_PACKAGE':
                          packageInfo.packageName,
                    },
                  );
                  await intent.launch();
                }
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
      return;
    }
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        DateTime dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        if (dateTime.isBefore(now)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('You cannot choose a past time'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        String formatted =
            "${dateTime.day}/${dateTime.month}/${dateTime.year} ${time.format(context)}";

        setState(() {
          selectedDateTime = formatted;
        });
        ExerciseScheduleRequest req = ExerciseScheduleRequest(
            subCategory: widget.subCategoryId, scheduleTime: dateTime);
        if (context.mounted) {
          final scheduleExercise = context.read<ScheduleExerciseUseCase>();
          await scheduleExercise.call(params: req);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: Text(
                  'Your schedule has been successfully registered \n $formatted'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDateTime(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: SwitchImageType.buildImage(
                  widget.icon,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  color: AppColors.black,
                )),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                selectedDateTime,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

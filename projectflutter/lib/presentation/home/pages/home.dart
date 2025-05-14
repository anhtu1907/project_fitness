import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/home/widgets/activity_status.dart';
import 'package:projectflutter/presentation/home/widgets/bmi_review.dart';
import 'package:projectflutter/presentation/home/widgets/header.dart';
import 'package:projectflutter/presentation/home/widgets/latest_workout.dart';
import 'package:projectflutter/presentation/home/widgets/what_train_row.dart';
import 'package:projectflutter/presentation/profile/pages/workout_progress.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Header(),
                SizedBox(
                  height: media.width * 0.05,
                ),
                const BmiReview(),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Workout',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        AppNavigator.push(context, const WorkoutProgressPage());
                      },
                      child: Text(
                        'See More',
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                const LatestWorkout(),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  'Activity Status',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                const ActivityStatus(),
                SizedBox(
                  height: media.width * 0.02,
                ),
                Text(
                  'Meals Plan',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                Text(
                  'What Do You Want to Train',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                const WhatTrainRow()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

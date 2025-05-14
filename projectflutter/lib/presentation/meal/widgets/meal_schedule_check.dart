import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/meal/pages/meal_schedule.dart';

class MealScheduleCheck extends StatelessWidget {
  const MealScheduleCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
          color: AppColors.primaryColor1.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Meal Schedule',
            style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 70,
            height: 25,
            child: RoundButton(
                title: "Check",
                type: RoundButtonType.bgGradient,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  AppNavigator.push(context, const MealSchedule());
                }),
          )
        ],
      ),
    );
  }
}

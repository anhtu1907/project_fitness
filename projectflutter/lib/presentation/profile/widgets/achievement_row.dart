import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class AchievementRow extends StatelessWidget {
  final String image;
  final String name;
  final double kcal;
  final double percent;
  final int totalExercise;

  const AchievementRow(
      {super.key,
      required this.image,
      required this.name,
      required this.kcal,
      required this.percent,
      required this.totalExercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '$totalExercise Exercises | ${kcal.toStringAsFixed(0)} Calories Burn',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          )),
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 10,
            percent: percent,
            center: Image.asset(
              AppImages.cup,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
            progressColor: const Color(0xFF90C67C),
            backgroundColor: Colors.grey[200]!,
            circularStrokeCap: CircularStrokeCap.round,
          )
        ],
      ),
    );
  }
}

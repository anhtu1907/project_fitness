import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class WorkoutHistory extends StatelessWidget {
  final String image;
  final String name;
  final int duration;
  final double kcal;
  final String time;
  final int totalExercise;

  const WorkoutHistory(
      {super.key,
      required this.image,
      required this.name,
      required this.duration,
      required this.kcal,
      required this.time,
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
                '$totalExercise Exercises | ${kcal.toStringAsFixed(0)} Calories Burn | $duration seconds',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          )),
          Text(
            time,
            style: TextStyle(color: AppColors.gray, fontSize: 14),
          )
        ],
      ),
    );
  }
}

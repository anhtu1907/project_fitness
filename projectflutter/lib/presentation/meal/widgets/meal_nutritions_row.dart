import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class MealNutritionsRow extends StatelessWidget {
  final String title;
  final double value;
  final double totalValue;
  final String image;
  final String unit;

  const MealNutritionsRow(
      {super.key,
      required this.title,
      required this.value,
      required this.totalValue,
      required this.image,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Image.asset(
                image,
                width: 20,
                height: 20,
              ),
              const Spacer(),
              Text(
                '${value.toStringAsFixed(0)} / ${totalValue.toStringAsFixed(0)} $unit',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          SimpleAnimationProgressBar(
            height: 10,
            width: media.width - 30,
            backgroundColor: Colors.grey.shade100,
            foregrondColor: Colors.purple,
            ratio: totalValue > 0 ? (value / totalValue).clamp(0.0, 1.0) : 0.0,
            direction: Axis.horizontal,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 3),
            borderRadius: BorderRadius.circular(7.5),
            gradientColor: LinearGradient(
                colors: value >= totalValue
                    ? AppColors.warningG
                    : AppColors.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
        ],
      ),
    );
  }
}

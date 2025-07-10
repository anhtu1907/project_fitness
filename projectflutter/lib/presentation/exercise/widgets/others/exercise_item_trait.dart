import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class ExerciseItemTrait extends StatelessWidget {
  const ExerciseItemTrait(
      {super.key, required this.duration, required this.totalWorkout, required this.categoryName});

  final String duration;
  final int totalWorkout;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            categoryName,
            style: TextStyle(color: Colors.white, fontSize: AppFontSize.value16Text(context)),
          ),
          SizedBox(height: media.height * 0.02),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.gray.withOpacity(0.2)
              ),
              color: AppColors.white.withOpacity(0.2)
            ),
            child: Text(
              '$totalWorkout exercises | $duration mins',
              style: TextStyle(color: Colors.white, fontSize: AppFontSize.value12Text(context)),
            ),
          ),
        ],
      ),
    );
  }
}

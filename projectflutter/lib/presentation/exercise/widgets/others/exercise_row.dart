import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';

class ExercisesRow extends StatelessWidget {
  final ExercisesEntity exercises;
  final VoidCallback onPressed;
  const ExercisesRow(
      {super.key, required this.exercises, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SwitchImageType.buildImage(
              AppImages.arm,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercises.exerciseName,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                _formatDuration(exercises.duration),
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 12,
                ),
              ),
            ],
          )),
          IconButton(
              onPressed: onPressed,
              icon: SwitchImageType.buildImage(
                "assets/images/next_go.png",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }
}

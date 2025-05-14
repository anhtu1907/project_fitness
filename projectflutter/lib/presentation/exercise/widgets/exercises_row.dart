import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class ExercisesRow extends StatelessWidget {
  final String image;
  final String name;
  final int duration;
  final VoidCallback onPressed;

  const ExercisesRow(
      {super.key,
      required this.image,
      required this.name,
      required this.duration,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return Material(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              ClipRRect(
                child: Image.network(
                  image,
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
                    name,
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: TextStyle(
                        color: AppColors.primaryColor1,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

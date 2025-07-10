import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

class WorkoutRow extends StatelessWidget {
  final String image;
  final String name;
  final int duration;
  final double kcal;
  final double progress;
  final VoidCallback onPressed;

  const WorkoutRow(
      {super.key,
      required this.image,
      required this.name,
      required this.duration,
      required this.kcal,
      this.progress = 0.0,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.gray.withOpacity(0.2),
            width: 1
          ),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
           SizedBox(
            width: media.width*0.04,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.content(context),
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '${kcal.toStringAsFixed(0)} Calories Burn | ${duration <= 1 ? 0 : duration} mins',
                style: TextStyle(color: AppColors.gray,fontSize: AppFontSize.content(context),),
              ),
              const SizedBox(
                height: 4,
              ),
              SimpleAnimationProgressBar(
                height: 15,
                width: media.width * 0.5,
                backgroundColor: Colors.grey.shade300,
                foregrondColor: Colors.purple,
                ratio: progress,
                direction: Axis.horizontal,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(seconds: 3),
                borderRadius: BorderRadius.circular(7.5),
                gradientColor: LinearGradient(
                    colors: AppColors.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
            ],
          )),
          IconButton(
            onPressed: onPressed,
            icon: Image.asset(
              AppImages.nextIcon,
              width: 35,
              height: 35,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/cell/title_sub_title_cell_time_result.dart';
import 'package:projectflutter/presentation/home/pages/tabs.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseResultPage extends StatelessWidget {
  final int resetBatch;
  final int totalExercise;
  final double kcal;
  final int duration;
  final int? day;
  final bool markAsDayCompleted;
  const ExerciseResultPage({
    super.key,
    required this.resetBatch,
    required this.totalExercise,
    required this.kcal,
    required this.duration,
    this.day,
    this.markAsDayCompleted = false,
  });
  // const ExerciseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SwitchImageType.buildImage(
                          AppImages.completeExercise,
                          width: width * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: width * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Congratulations. You Have Finished Your Workout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Exercises is king and nutrition is queen. Combine the two and you will have a kingdom',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.gray,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: totalExercise,
                                  subtitle: "Exercises",
                                  unit: "",
                                ),
                              ),
                              SizedBox(width: width * 0.025),
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: kcal.toInt(),
                                  subtitle: "Burned",
                                  unit: "kcal",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.05),
                          Row(
                            children: [
                              Expanded(
                                child: TitleSubTitleCellTimeResult(
                                  value: duration,
                                  subtitle: "Duration",
                                ),
                              ),
                              SizedBox(width: width * 0.025),
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: resetBatch,
                                  subtitle: "ResetBatch",
                                  unit: "",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    width: width * 0.8,
                    height: height * 0.06,
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        if (markAsDayCompleted && day != null) {
                          await prefs.setBool('day_${day}_completed', true);
                        }
                        if (day == 1 && !prefs.containsKey('plan_start_date')) {
                          final today = DateTime.now();
                          await prefs.setString('plan_start_date', today.toIso8601String());
                        }
                        AppNavigator.pushAndRemoveUntil(
                            context, const TabsPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          fontSize: AppFontSize.value16Text(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

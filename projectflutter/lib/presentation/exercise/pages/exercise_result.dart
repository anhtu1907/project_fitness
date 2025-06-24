import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/widgets/title_sub_title_cell_time_result.dart';
import 'package:projectflutter/presentation/home/pages/tabs.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell.dart';


class ExerciseResultPage extends StatelessWidget {
  //   final int resetBatch;
//   final int totalExercise;
//   final double kcal;
//   final int duration;

//   const ExerciseResultPage(
//       {super.key,
//       required this.resetBatch,
//       required this.totalExercise,
//       required this.kcal,
//       required this.duration});
  const ExerciseResultPage({super.key});

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
                        child: Image.asset(
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
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: 5,
                                  subtitle: "Exercises",
                                  unit: "",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: 1230,
                                  subtitle: "Burned",
                                  unit: "kcal",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TitleSubTitleCellTimeResult(
                                  value: 120,
                                  subtitle: "Duration",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TitleSubtitleCell(
                                  value: 0,
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
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        AppNavigator.pushAndRemoveUntil(context, const TabsPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Finish",
                        style: TextStyle(
                          fontSize: 16,
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

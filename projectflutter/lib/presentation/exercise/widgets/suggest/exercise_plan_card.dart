import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';

class ExercisePlanCard extends StatelessWidget {
  final String itemDateFormatted;
  final int day;
  final bool isUpcoming;
  final bool isFirstDay;
  final String duration;
  final double kcal;
  final DateTime itemDate;
  final DateTime todayDate;
  final bool isUnlocked;
  final String imagePath;
  final int subCategoryId;
  final String level;
  final bool isCompleted;

  const ExercisePlanCard({
    super.key,
    required this.itemDateFormatted,
    required this.day,
    required this.isUpcoming,
    required this.isFirstDay,
    required this.duration,
    required this.kcal,
    required this.imagePath,
    required this.itemDate,
    required this.todayDate,
    required this.isUnlocked,
    required this.subCategoryId,
    required this.isCompleted,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final isInThePastOrToday = itemDate.isBefore(todayDate.add(const Duration(days: 1)));
    final realUnlock = isUnlocked && isInThePastOrToday;
    return GestureDetector(
      onTap:(realUnlock && !isCompleted)
          ? () {
              AppNavigator.push(
                context,
                ExerciseBySubCategoryView(
                  subCategoryId: subCategoryId,
                  image: imagePath,
                  day: day,
                  markAsDayCompleted: true,
                  level: level,
                ),
              );
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: isFirstDay ? 16 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemDateFormatted,
                        style: TextStyle(
                            color: AppColors.gray.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.value12Text(context)),
                      ),
                      SizedBox(
                        height: media.height * 0.001,
                      ),
                      Text(
                        'Day $day',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: realUnlock
                                ? AppFontSize.value30Text(context)
                                : AppFontSize.value24Text(context)),
                      ),
                      SizedBox(
                        height: media.height * 0.001,
                      ),
                      Row(
                        children: [
                          Text(
                            '$duration mins',
                            style: TextStyle(
                                fontSize: AppFontSize.value11Text(context)),
                          ),
                          SizedBox(width: media.width * 0.01),
                          Text(
                            ' | ',
                            style: TextStyle(
                                color: AppColors.gray.withOpacity(0.3),
                                fontSize: AppFontSize.value11Text(context)),
                          ),
                          SizedBox(width: media.width * 0.01),
                          Text('${kcal.toStringAsFixed(0)} kcal',
                              style: TextStyle(
                                  fontSize: AppFontSize.value11Text(context)))
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SwitchImageType.buildImage(
                            imagePath,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: media.height * 0.02),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SizedBox(
                width: double.infinity,
                height: media.height * 0.06,
                child: ElevatedButton(
                  onPressed: (realUnlock && !isCompleted)
                      ? ()  {
                          AppNavigator.push(
                            context,
                            ExerciseBySubCategoryView(
                              subCategoryId: subCategoryId,
                              image: imagePath,
                              day: day,
                              markAsDayCompleted: true,
                              level: level,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (realUnlock && !isCompleted)
                        ? AppColors.primaryColor3
                        : AppColors.gray.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(isCompleted ?'Completed' : 'Start Now',
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

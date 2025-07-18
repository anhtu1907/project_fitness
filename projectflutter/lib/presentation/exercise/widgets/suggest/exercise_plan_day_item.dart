import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/dash_line_painter.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/exercise_plan_card.dart';

class ExercisePlanDayItem extends StatelessWidget {
  final DateTime itemDate;
  final DateTime todayDate;
  final int actualDay;
  final bool isFirstDay;
  final bool isLast;
  final bool showWeekHeader;
  final int weekNumber;
  final String level;
  final String duration;
  final double kcal;
  final String imagePath;
  final int subCategoryId;
  final Map<int, bool> isCompleted;

  const ExercisePlanDayItem({
    super.key,
    required this.itemDate,
    required this.todayDate,
    required this.actualDay,
    required this.isFirstDay,
    required this.isLast,
    required this.showWeekHeader,
    required this.weekNumber,
    required this.level,
    required this.duration,
    required this.kcal,
    required this.imagePath,
    required this.isCompleted,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {

    int getLastCompletedDay(Map<int, bool> isCompleted) {
      final completedDays = isCompleted.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key);

      if (completedDays.isEmpty) return 0;
      return completedDays.reduce((a, b) => a > b ? a : b);
    }

    final media = MediaQuery.of(context).size;
    final lastCompletedDay = getLastCompletedDay(isCompleted);

    final itemDay = DateTime(itemDate.year, itemDate.month, itemDate.day);
    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final tomorrow = today.add(const Duration(days: 1));

    final isToday = itemDay == today;
    final isUpcoming = itemDay == tomorrow;

    final itemDateFormatted = DateFormat("MMM dd, EEE").format(itemDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showWeekHeader)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Week $weekNumber',
              style: TextStyle(
                fontSize: AppFontSize.value22Text(context),
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment:
                isLast ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Container(
                    width: media.width * 0.06,
                    height: media.height * 0.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                        isToday ? AppColors.white : Colors.grey.shade300,
                        width: 4,
                      ),
                      boxShadow: isToday
                          ? [
                        BoxShadow(
                          color:
                          AppColors.primaryColor3.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ]
                          : [],
                      color:
                      isToday ? AppColors.primaryColor3 : Colors.white,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: CustomPaint(
                        painter: DashedLinePainter(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: Container(width: 2),
                      ),
                    ),
                ],
              ),
              SizedBox(width: media.width * 0.06),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isToday || isUpcoming)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          isToday ? 'Today' : 'Upcoming',
                          style: TextStyle(
                            color: isToday ? AppColors.black : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.value20Text(context),
                          ),
                        ),
                      ),
                    SizedBox(height: media.height * 0.01),
                    ExercisePlanCard(
                      itemDateFormatted: itemDateFormatted,
                      day: actualDay,
                      imagePath: imagePath,
                      isUpcoming: isUpcoming,
                      isFirstDay: isFirstDay,
                      itemDate: itemDate,
                      todayDate: todayDate,
                      subCategoryId: subCategoryId,
                      isCompleted: isCompleted[actualDay] ?? false,
                      isUnlocked: actualDay == lastCompletedDay + 1 || isToday,
                      level: level,
                      duration: duration,
                      kcal: kcal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

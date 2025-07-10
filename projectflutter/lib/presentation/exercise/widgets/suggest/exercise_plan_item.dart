// exercise_plan_item.dart (hoặc ở cuối file cũ trước cũng được)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/dash_line_painter.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/exercise_plan_card.dart';

class ExercisePlanItem extends StatefulWidget {
  final Map<int, List<ExercisesEntity>> groupedSubCategory;
  final Map<int, int> durationBySubCategory;
  final Map<int, double> kcalBySubCategory;
  final List<ExerciseSubCategoryEntity> subCategories;

  const ExercisePlanItem({
    super.key,
    required this.groupedSubCategory,
    required this.durationBySubCategory,
    required this.kcalBySubCategory,
    required this.subCategories,
  });

  @override
  State<ExercisePlanItem> createState() => _ExercisePlanItemState();
}

class _ExercisePlanItemState extends State<ExercisePlanItem> {
  int extractDaysFromProgramName(String name) {
    final match =
    RegExp(r'(\d+)\s*days?', caseSensitive: false).firstMatch(name);
    if (match != null) {
      return int.tryParse(match.group(1)!) ?? 0;
    }
    return 0;
  }

  var programName = '28 days';
  late int totalDays;

  @override
  void initState() {
    super.initState();
    totalDays = extractDaysFromProgramName(programName);
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final today = DateTime.now();
    return ListView.builder(
      itemCount: widget.subCategories.length,
      padding: const EdgeInsets.all(30),
      itemBuilder: (context, index) {
        final day = index + 1;
        final itemDate = today.add(Duration(days: index));
        final isToday = itemDate.day == today.day &&
            itemDate.month == today.month &&
            itemDate.year == today.year;
        final itemDateFormatted =
        DateFormat("MMM dd, EEE").format(itemDate);
        final isLast = index == totalDays - 1;
        final isUpcoming =
        itemDate.isAtSameMomentAs(today.add(const Duration(days: 1)));
        String _formatDuration(int seconds) {
          final duration = Duration(seconds: seconds);
          String twoDigits(int n) => n.toString().padLeft(2, '0');
          final minutes = twoDigits(duration.inMinutes.remainder(60));
          final secs = twoDigits(duration.inSeconds.remainder(60));
          return "$minutes:$secs";
        }
        final isFirstDay = index == 0;
        final subCategory = widget.subCategories[index];
        final duration = widget.durationBySubCategory[subCategory.id] ?? 0;
        final kcal = widget.kcalBySubCategory[subCategory.id] ?? 0.0;
        final imagePath = subCategory.subCategoryImage;
        final sub = widget.subCategories[index];
        final subCategoryId = sub.id;

        final exercises = widget.groupedSubCategory[subCategoryId] ?? [];
        final level = exercises.firstWhere(
              (e) => e.mode != null,
          orElse: () => exercises.first,
        ).mode?.modeName ?? 'Unknown';

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: isLast ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Container(
                    width: media.width * 0.06,
                    height: media.height * 0.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isToday ? AppColors.white : Colors.grey.shade300,
                        width: 4,
                      ),
                      boxShadow: isToday
                          ? [
                        BoxShadow(
                          color: AppColors.primaryColor3.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ]
                          : [],
                      color: isToday ? AppColors.primaryColor3 : Colors.white,
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
                      day: day,
                      isToday: isToday,
                      imagePath: imagePath,
                      isUpcoming: isUpcoming,
                      isFirstDay: isFirstDay,
                      subCategoryId: subCategoryId,
                      level: level,
                      duration: _formatDuration(duration),
                      kcal: kcal,

                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

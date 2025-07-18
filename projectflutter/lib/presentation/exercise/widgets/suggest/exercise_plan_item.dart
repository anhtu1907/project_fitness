import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/exercise_plan_day_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExercisePlanItem extends StatefulWidget {
  final Map<int, List<ExercisesEntity>> groupedSubCategory;
  final Map<int, int> durationBySubCategory;
  final Map<int, double> kcalBySubCategory;
  final List<ExerciseSubCategoryEntity> subCategories;
  final List<bool> selectedDays;
  final Map<int, bool> isCompleted;
  final Map<int, String> levelBySubCategoryId;
  const ExercisePlanItem(
      {super.key,
      required this.groupedSubCategory,
      required this.durationBySubCategory,
      required this.kcalBySubCategory,
      required this.subCategories,
        required this.isCompleted,
        required this.levelBySubCategoryId,
      required this.selectedDays});

  @override
  State<ExercisePlanItem> createState() => _ExercisePlanItemState();
}

class _ExercisePlanItemState extends State<ExercisePlanItem> {
  late final int totalDays = 28;
  Future<DateTime?> _loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final startDateString = prefs.getString('plan_start_date');
    if (startDateString != null) {
      return DateTime.parse(startDateString);
    } else {
      final now = DateTime.now();
      await prefs.setString('plan_start_date', now.toIso8601String());
      return now;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime?>(
      future: _loadStartDate(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final startDate = snapshot.data!;
        final now = DateTime.now();
        final daysPassed = now.difference(startDate).inDays;
        final todayDate = startDate.add(Duration(days: daysPassed));

        final List<Widget> planItems = [];
        int? currentWeek;
        int actualDayCount = 0;

        for (int index = 0; index < widget.subCategories.length; index++) {
          final itemDate = startDate.add(Duration(days: index));
          final weekdayIndex = itemDate.weekday - 1;

          if (!widget.selectedDays[weekdayIndex]) continue;

          actualDayCount++;
          final startOfWeek = startDate.subtract(Duration(days: startDate.weekday - 1));
          final weekNumber = ((itemDate.difference(startOfWeek).inDays) ~/ 7) + 1;

          final isLast = index == totalDays - 1;
          final isFirstDay = actualDayCount == 1;
          final showWeekHeader = currentWeek != weekNumber;
          currentWeek = weekNumber;

          final subCategory = widget.subCategories[index];
          final subCategoryId = subCategory.id;
          final imagePath = subCategory.subCategoryImage;
          final duration =
          _formatDuration(widget.durationBySubCategory[subCategoryId] ?? 0);
          final kcal = widget.kcalBySubCategory[subCategoryId] ?? 0.0;
          final level = widget.levelBySubCategoryId[subCategoryId] ?? 'Unknown';

          planItems.add(
            ExercisePlanDayItem(
              itemDate: itemDate,
              todayDate: todayDate,
              actualDay: actualDayCount,
              isFirstDay: isFirstDay,
              isLast: isLast,
              showWeekHeader: showWeekHeader,
              isCompleted: widget.isCompleted,
              weekNumber: weekNumber,
              level: level,
              duration: duration,
              kcal: kcal,
              imagePath: imagePath,
              subCategoryId: subCategoryId,
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(30),
          children: planItems,
        );
      },
    );
  }
  //
  // bool _isSameDate(DateTime a, DateTime b) =>
  //     a.day == b.day && a.month == b.month && a.year == b.year;

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}

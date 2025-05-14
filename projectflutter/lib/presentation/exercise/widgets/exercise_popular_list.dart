import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_sub_category_row.dart';

class ExercisePopularList extends StatelessWidget {
  final String categoryName;
  final void Function(ExerciseSubCategoryEntity) onPressed;
  final List<ExerciseSubCategoryEntity> list;
  final Map<String, int> duration;
  const ExercisePopularList(
      {super.key,
      required this.categoryName,
      required this.onPressed,
      required this.duration,
      required this.list});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }


    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            categoryName,
            style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 120,
          ),
          TextButton(
              onPressed: () {
                AppNavigator.push(
                    context,
                    ExerciseSubCategoryListPage(
                        categoryName: categoryName,
                        duration: duration,
                        total: list));
              },
              child: Text(
                'See All',
                style: TextStyle(color: AppColors.primaryColor1),
              ))
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list.take(3).map((item) {
          return ExerciseSubcategoryRow(
            image: exerciseSubCategory[item.id].toString(),
            name: item.subCategoryName,
            duration: _formatDuration(duration[item.subCategoryName] ?? 0),
            level: item.mode!.modeName,
            onPressed: () => onPressed(item),
          );
        }).toList(),
      )
    ]);
  }
}

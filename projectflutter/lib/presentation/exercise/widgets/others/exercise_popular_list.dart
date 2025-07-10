import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_list.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_program_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_row.dart';

class ExercisePopularList extends StatelessWidget {
  final String categoryName;
  final void Function(ExerciseSubCategoryProgramEntity) onPressed;
  final List<ExerciseSubCategoryProgramEntity> list;
  final Map<String, int> duration;
  final String level;
  const ExercisePopularList(
      {super.key,
      required this.categoryName,
      required this.onPressed,
      required this.duration,
      required this.level,
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
    var media = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            categoryName,
            style: TextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.value14Text(context),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: media.width * 0.3,
          ),
          TextButton(
              onPressed: () {
                AppNavigator.push(
                    context,
                    ExerciseSubCategoryProgramListPage(
                        categoryName: categoryName,
                        duration: duration,
                        level: level,
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExerciseSubcategoryRow(
              image: item.subCategory!.subCategoryImage,
              name: item.subCategory!.subCategoryName,
              duration: _formatDuration(
                  duration[item.subCategory!.subCategoryName] ?? 0),
              level: level,
              onPressed: () => onPressed(item),
            ),
          );
        }).toList(),
      )
    ]);
  }
}

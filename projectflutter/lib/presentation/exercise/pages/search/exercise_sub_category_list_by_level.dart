import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_row.dart';

class ExerciseSubCategoryListByLevelPage extends StatelessWidget {
  final List<ExerciseSubCategoryEntity> total;
  final String categoryName;
  final Map<String, int> duration;
  final Map<int, String>  level;
  const ExerciseSubCategoryListByLevelPage(
      {super.key,
      required this.categoryName,
      required this.duration,
      required this.total,
      required this.level});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return Scaffold(
      appBar: BasicAppBar(
        title: Text(categoryName,
            style: TextStyle(
                fontSize: AppFontSize.titleAppBar(context),
                fontWeight: FontWeight.w700)),
        subTitle: Text(
          '${total.length} workouts',
          style: TextStyle(
              color: AppColors.gray,
              fontSize: AppFontSize.subTitleAppBar(context),
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: ListView.builder(
            itemCount: total.length,
            itemBuilder: (context, index) {
              final list = total[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExerciseSubcategoryRow(
                    image: list.subCategoryImage,
                    name: list.subCategoryName,
                    duration:
                        _formatDuration(duration[list.subCategoryName] ?? 0),
                    level: level[list.id] ?? 'Unknown',
                    onPressed: () {
                      AppNavigator.push(
                          context,
                          ExerciseBySubCategoryView(
                            subCategoryId: total[index].id,
                            level: level[list.id] ?? 'Unknown',
                            image: total[index].subCategoryImage,
                          ));
                    }),
              );
            },
          )),
    );
  }
}

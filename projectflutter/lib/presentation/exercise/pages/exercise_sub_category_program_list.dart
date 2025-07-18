import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_row.dart';

class ExerciseSubCategoryProgramListPage extends StatelessWidget {
  final List<(ExerciseSubCategoryProgramEntity, String)> total;
  final String categoryName;
  final Map<String, int> duration;
  const ExerciseSubCategoryProgramListPage(
      {super.key,
      required this.categoryName,
      required this.duration,
      required this.total});

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
              final sub = total[index].$1;
              final mode = total[index].$2;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExerciseSubcategoryRow(
                    image: sub.subCategory!.subCategoryImage,
                    name:sub.subCategory!.subCategoryName,
                    duration: _formatDuration(
                        duration[sub.subCategory!.subCategoryName] ?? 0),
                    level: mode,
                    onPressed: () {
                      AppNavigator.push(
                          context,
                          ExerciseBySubCategoryView(
                            subCategoryId: sub.subCategory!.id,
                            level: mode,
                            image: sub.subCategory!.subCategoryImage,
                          ));
                    }),
              );
            },
          )),
    );
  }
}

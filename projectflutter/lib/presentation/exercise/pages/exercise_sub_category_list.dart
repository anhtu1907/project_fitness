import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_sub_category_row.dart';

class ExerciseSubCategoryListPage extends StatelessWidget {
  final List<ExerciseSubCategoryEntity> total;
  final String categoryName;
  final Map<String, int> duration;
  const ExerciseSubCategoryListPage(
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
        title: Text(categoryName),
        subTitle: Text(
          '${total.length} workouts',
          style: TextStyle(
              color: AppColors.gray, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: ListView.builder(
            itemCount: total.length,
            itemBuilder: (context, index) {
              return ExerciseSubcategoryRow(
                  image: exerciseSubCategory[total[index].id].toString(),
                  name: total[index].subCategoryName,
                  duration: _formatDuration(
                      duration[total[index].subCategoryName] ?? 0),
                  level: total[index].mode!.modeName,
                  onPressed: () {
                    AppNavigator.push(
                        context,
                        ExerciseBySubCategoryView(
                            subCategoryId: total[index].id));
                  });
            },
          )),
    );
  }
}

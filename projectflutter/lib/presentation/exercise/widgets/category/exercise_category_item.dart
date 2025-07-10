import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_category.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_list.dart';

class ExerciseCategoryItem extends StatelessWidget {
  final List<ExerciseSubCategoryEntity> total;
  final Map<String, int> duration;
  final String level;
  const ExerciseCategoryItem(
      {super.key, required this.total, required this.duration, required this.level});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseSubCategoryListPage(
              categoryName: total.first.category.first.categoryName,
              total: total,
              level: level,
              duration: duration,
            ));
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: Container(
            width: media.width * 0.13,
            height: media.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.black.withOpacity(0.25)
              )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                exerciseCategory[total.first.id].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: media.height * 0.015),
        Text(
          total.first.category.first.categoryName,
          style: TextStyle(color: AppColors.black, fontSize: AppFontSize.value13Text(context)),
        )
      ]),
    );
  }
}

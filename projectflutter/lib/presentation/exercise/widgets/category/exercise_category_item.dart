import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_list.dart';

class ExerciseCategoryItem extends StatelessWidget {
  final String categoryName;
  final List<ExerciseSubCategoryEntity> total;
  final Map<int, int> duration;
  final Map<int, String> level;
  const ExerciseCategoryItem(
      {super.key,
      required this.total,
        required this.categoryName,
      required this.duration,
      required this.level});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseSubCategoryListPage(
              categoryName: categoryName,
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
                border: Border.all(color: AppColors.black.withOpacity(0.25))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SwitchImageType.buildImage(
                total.first.category.first.categoryImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: media.height * 0.015),
        Text(
          categoryName,
          style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.value13Text(context)),
        )
      ]),
    );
  }
}

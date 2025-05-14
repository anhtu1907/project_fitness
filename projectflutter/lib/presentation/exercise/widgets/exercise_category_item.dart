import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_category.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_list.dart';

class ExerciseCategoryItem extends StatelessWidget {
  final List<ExerciseSubCategoryEntity> total;
  final Map<String, int> duration;
  const ExerciseCategoryItem(
      {super.key, required this.total, required this.duration});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseSubCategoryListPage(
              categoryName: total.first.category!.categoryName,
              total: total,
              duration: duration,
            ));
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
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
        const SizedBox(height: 8),
        Text(
          total.first.category!.categoryName,
          style: TextStyle(color: AppColors.black),
        )
      ]),
    );
  }
}

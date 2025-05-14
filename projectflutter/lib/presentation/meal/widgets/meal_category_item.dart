import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/data/meal_category.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/presentation/meal/pages/meal_sub_category_list.dart';

class MealCategoryItem extends StatelessWidget {
  final List<MealSubCategoryEntity> total;
  final Map<String, double> kcal;
  final Map<String, int> totalFood;
  const MealCategoryItem(
      {super.key,
      required this.total,
      required this.kcal,
      required this.totalFood});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            MealSubCategoryListPage(
              categoryName: total.first.category!.categoryName,
              total: total,
              kcal: kcal,
              totalFood: totalFood,
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
                mealCategoryImage[total.first.category!.id].toString(),
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

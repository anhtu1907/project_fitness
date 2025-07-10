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

  const MealCategoryItem({
    super.key,
    required this.total,
    required this.kcal,
    required this.totalFood,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final imageSize = width * 0.5;

        return InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              MealSubCategoryListPage(
                categoryName: total.first.category!.categoryName,
                total: total,
                kcal: kcal,
                totalFood: totalFood,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    color: AppColors.black.withOpacity(0.15)
                  ),
                  borderRadius: BorderRadius.circular(imageSize / 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize / 2),
                  child: Image.asset(
                    mealCategoryImage[total.first.category!.id].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              Text(
                total.first.category!.categoryName,
                style: TextStyle(
                    color: AppColors.gray,
                    fontSize: width * 0.15,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

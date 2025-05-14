import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';

class MealGridItem extends StatelessWidget {
  final MealsEntity meal;
  const MealGridItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 200,
      decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                color: AppColors.black.withOpacity(0.2),
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            meal.mealImage == '' ? AppImages.snack : meal.mealImage,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              meal.mealName,
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "${meal.weight.toStringAsFixed(0)} gram | ${meal.kcal.toStringAsFixed(0)} kcal",
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 90,
              height: 35,
              child: RoundButton(
                  fontSize: 12,
                  type: RoundButtonType.bgSGradient,
                  title: "View",
                  onPressed: () {
                    AppNavigator.push(
                        context, MealInfoDetails(mealId: meal.id));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

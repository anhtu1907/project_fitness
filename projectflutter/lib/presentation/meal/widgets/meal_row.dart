import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';

class MealRow extends StatelessWidget {
  final MealsEntity entity;

  const MealRow({super.key, required this.entity});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          ClipRRect(
            // borderRadius: BorderRadius.circular(30),
            child: Image.network(
              entity.mealImage == '' ? AppImages.vegetable : entity.mealImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.mealName,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '${entity.weight.toStringAsFixed(0)} gram | ${entity.kcal.toStringAsFixed(0)} kcal',
                style: TextStyle(color: AppColors.gray, fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          )),
          IconButton(
            onPressed: () {
              AppNavigator.push(context, MealInfoDetails(mealId: entity.id));
            },
            icon: Image.asset(
              AppImages.nextIcon,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

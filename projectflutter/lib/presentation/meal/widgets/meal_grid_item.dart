import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';

class MealGridItem extends StatelessWidget {
  final MealsEntity meal;
  const MealGridItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: AppColors.black.withOpacity(0.1),
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SwitchImageType.buildImage(
                      meal.mealImage.isEmpty ? AppImages.snack : meal.mealImage,
                      width: width * 0.3,
                      height: width * 0.3,
                      fit: BoxFit.contain,
                    )),
                const SizedBox(height: 10),
                Text(
                  meal.mealName,
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.caption(context),
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${meal.weight.toStringAsFixed(0)} gram | ${meal.kcal.toStringAsFixed(0)} kcal",
                  style: TextStyle(
                      color: AppColors.gray,
                      fontSize: AppFontSize.content(context)),
                ),
                const Spacer(),
                SizedBox(
                  width: width * 0.5,
                  height: width * 0.2,
                  child: RoundButton(
                    fontSize: AppFontSize.content(context),
                    type: RoundButtonType.bgSGradient,
                    title: "View",
                    onPressed: () {
                      AppNavigator.push(
                          context, MealInfoDetails(mealId: meal.id));
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

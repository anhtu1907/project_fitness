import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/data/meal_sub_category.dart';
import 'package:projectflutter/presentation/meal/pages/meal_by_sub_category.dart';

class MealSubCategoryCard extends StatelessWidget {
  final int subCategoryId;
  final String subCategoryName;
  final String description;
  final double kcal;
  final int totalFood;
  final VoidCallback onPressed;

  const MealSubCategoryCard(
      {super.key,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.description,
      required this.kcal,
      required this.totalFood,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            MealBySubCategory(
              subCategoryId: subCategoryId,
              categoryName: subCategoryName,
            ));
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            color: AppColors.gray, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                mealSubCategoryImage[subCategoryId].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration:
                    BoxDecoration(color: AppColors.black.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCategoryName,
                      style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${kcal.toStringAsFixed(0)} Kcal | ',
                          style: TextStyle(
                              color: AppColors.primaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$totalFood foods',
                          style:
                              TextStyle(color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: 100,
                            height: 25,
                            child: RoundButton(
                              title: "Add Plan",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              onPressed: () {},
                            )),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

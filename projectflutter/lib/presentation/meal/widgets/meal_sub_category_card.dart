import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/meal_sub_category.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_sub_category.dart';
import 'package:projectflutter/domain/meal/usecase/save_record_meal.dart';
import 'package:projectflutter/presentation/meal/pages/meal_by_sub_category.dart';

class MealSubCategoryCard extends StatelessWidget {
  final int subCategoryId;
  final String subCategoryName;
  final String description;
  final String subCategoryImage;
  final double kcal;
  final int totalFood;

  const MealSubCategoryCard(
      {super.key,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.description,
      required this.subCategoryImage,
      required this.kcal,
      required this.totalFood});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
        height: media.width * 0.55,
        decoration: BoxDecoration(
            color: AppColors.gray, borderRadius: BorderRadius.circular(30)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
                child: SwitchImageType.buildImage(
              subCategoryImage,
              fit: BoxFit.cover,
            )),
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
                          fontSize: AppFontSize.caption(context),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppFontSize.descriptionText(context),
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: media.height * 0.01,
                    ),
                    IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // RẤT QUAN TRỌNG
                          children: [
                            Text(
                              '${kcal.toStringAsFixed(0)} Kcal | ',
                              style: TextStyle(
                                color: AppColors.kcalColor,
                                fontSize: AppFontSize.caption(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$totalFood foods',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppFontSize.caption(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

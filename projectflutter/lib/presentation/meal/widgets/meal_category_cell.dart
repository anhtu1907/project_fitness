import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/meal_category.dart';

class MealCategoryCell extends StatelessWidget {
  final MealCategoryEntity category;
  final int index;
  final VoidCallback? onTap;
  const MealCategoryCell(
      {super.key, required this.category, required this.index, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isEvent = index % 2 == 0;
    List<String> imageList = [
      AppImages.meat,
      AppImages.cake,
      AppImages.fruit,
      AppImages.vegetable,
      AppImages.dairy,
      AppImages.nuts,
      AppImages.grains,
      AppImages.seafood,
      AppImages.snack
    ];
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 80,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEvent
                  ? [
                      AppColors.primaryColor2.withOpacity(0.5),
                      AppColors.primaryColor1.withOpacity(0.5)
                    ]
                  : [
                      AppColors.secondaryColor2.withOpacity(0.5),
                      AppColors.secondaryColor1.withOpacity(0.5)
                    ],
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17.5),
              child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(17.5)),
                  child: SwitchImageType.buildImage(
                    category.categoryImage == ''
                        ? imageList[index % imageList.length]
                        : category.categoryImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                category.categoryName,
                maxLines: 1,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

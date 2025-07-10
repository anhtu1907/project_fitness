import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/meal/pages/meal_by_sub_category.dart';

class MealSubCategoryItem extends StatelessWidget {
  final int subCategoryId;
  final String typeName;
  final String image;
  const MealSubCategoryItem(
      {super.key,
        required this.subCategoryId,
      required this.typeName,
      required this.image});

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
                MealBySubCategory(
                  subCategoryId: subCategoryId,
                  categoryName: typeName,
                ));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(imageSize / 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize / 2),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: height * 0.08),
              Text(
                typeName,
                style: TextStyle(
                    color: AppColors.gray,
                    fontSize: AppFontSize.caption(context),
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

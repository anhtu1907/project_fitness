import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_item_trait.dart';

class ExerciseSubCategoryCard extends StatelessWidget {
  final String name;
  final int subCategoryId;
  final String subName;

  const ExerciseSubCategoryCard(
      {super.key,
      required this.name,
      required this.subCategoryId,
      required this.subName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseBySubCategoryView(
                name: name, subCategoryId: subCategoryId));
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.gray, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                exerciseSubCategory[subCategoryId].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ExerciseItemTrait(categoryName: name, subName: subName),
            ),
          ],
        ),
      ),
    );
  }
}

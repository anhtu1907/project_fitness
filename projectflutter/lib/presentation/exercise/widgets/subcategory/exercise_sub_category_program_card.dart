import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_program_item_trait.dart';

class ExerciseSubCategoryProgramCard extends StatelessWidget {
  final String name;
  final int subCategoryId;
  final int totalWorkouts;
  final String image;
  final String level;
  const ExerciseSubCategoryProgramCard(
      {super.key,
      required this.name,
      required this.subCategoryId,
        required this.level,
      required this.totalWorkouts,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseBySubCategoryView(
              subCategoryId: subCategoryId,
              level: level,
              image: image,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.gray, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image,
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
              child: ExerciseProgramItemTrait(
                  categoryName: name, totalWorkouts: totalWorkouts),
            ),
          ],
        ),
      ),
    );
  }
}

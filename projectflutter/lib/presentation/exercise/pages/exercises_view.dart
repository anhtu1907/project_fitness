import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_category_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_list_category_popular.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_sections.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ExerciseCategoryList(),
            SizedBox(
              height: media.width * 0.05,
            ),
            Text(
              'Popular Workout',
              style: TextStyle(
                  color: AppColors.primaryColor1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            const ExerciseListCategoryPopular(),
            SizedBox(
              height: media.width * 0.05,
            ),
            const ExerciseSections()
          ],
        ),
      ),
    ));
  }
}

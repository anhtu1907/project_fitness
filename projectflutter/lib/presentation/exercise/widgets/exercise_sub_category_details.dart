import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/data/exercises_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_details.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercises_row.dart';
import 'package:projectflutter/presentation/exercise/widgets/title_sub_title_cell_kcal.dart';
import 'package:projectflutter/presentation/exercise/widgets/title_sub_title_cell_time.dart';
import 'package:projectflutter/presentation/exercise/widgets/title_subtitle_cell_level.dart';
import 'package:readmore/readmore.dart';

class ExerciseSubCategoryDetails extends StatelessWidget {
  final int subCategoryId;
  final String subCategoryName;
  final String description;
  final String level;
  final int totalDuration;
  final double kcal;
  final int totalExercise;
  final List<ExercisesEntity> exercises;

  const ExerciseSubCategoryDetails(
      {super.key,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.description,
      required this.level,
      required this.totalDuration,
      required this.exercises,
      required this.kcal,
      required this.totalExercise});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: false,
              expandedHeight: media.width * 0.5,
              automaticallyImplyLeading: false,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    exerciseSubCategory[subCategoryId].toString(),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        subCategoryName,
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: media.width * 0.01,
                  ),
                  _subTitle(level, totalDuration, kcal),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  ReadMoreText(
                    description,
                    trimLines: 4,
                    colorClickableText: AppColors.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Read More ...',
                    trimExpandedText: ' Read Less',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: 16,
                    ),
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    children: [
                      Text(
                        "Exercises",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '( ${totalExercise.toString()} )',
                        style: TextStyle(color: AppColors.gray, fontSize: 12),
                      )
                    ],
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return ExercisesRow(
                          image:
                              exerciseImageMap[exercises[index].id].toString(),
                          name: exercises[index].exerciseName,
                          duration: exercises[index].duration,
                          onPressed: () {
                            AppNavigator.push(
                                context,
                                ExerciseDetailsPage(
                                    exercises: exercises[index]));
                          });
                    },
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _subTitle(String level, int duration, double kcal) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: TitleSubtitleCellLevel(value: level, subtitle: "Level")),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            flex: 3,
            child: TitleSubTitleCellTime(value: duration, subtitle: "Times")),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 4,
          child: TitleSubTitleCellKcal(
            value: kcal,
            subtitle: "Calories",
          ),
        ),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button_workout.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';

class WhatTrainRow extends StatelessWidget {
  const WhatTrainRow({super.key});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return BlocProvider(
        create: (context) => ExercisesCubit()..listExercise(),
        child: BlocBuilder<ExercisesCubit, ExercisesState>(
            builder: (context, state) {
          if (state is ExercisesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadExercisesFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is ExercisesLoaded) {
            final listExercise = state.entity;
            final Map<String, List<ExercisesEntity>> groupedExercises = {};

            for (var exercise in listExercise) {
              if (exercise.modes == null) continue;

              for (var sub in exercise.subCategory) {
                final key = '${sub.id}-${exercise.modes.first.id}';
                groupedExercises.putIfAbsent(key, () => []).add(exercise);
              }
            }
            Map<String, List<ExercisesEntity>> groupedCategory = {};
            for (var exercise in state.entity) {
              for (var sub in exercise.subCategory) {
                final categoryName = sub.subCategoryName;
                if (groupedCategory.containsKey(categoryName)) {
                  groupedCategory[categoryName]!.add(exercise);
                } else {
                  groupedCategory[categoryName] = [exercise];
                }
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: groupedCategory.entries.take(4).map((entry) {
                    final list = entry.value;
                    var sub = list.first.subCategory.first;
                    var subCategoryId = sub.id;
                    var subCategoryImage = sub.subCategoryImage;
                    var subCategoryName = sub.subCategoryName;
                    var duration =
                        list.fold<int>(0, (sum, item) => sum += item.duration);
                    ExercisesEntity? exerciseForSub;
                    String? modeName;
                    for (var key in groupedExercises.keys) {
                      if (key.startsWith('$subCategoryId-')) {
                        final exercises = groupedExercises[key];
                        if (exercises != null && exercises.isNotEmpty) {
                          exerciseForSub = exercises.first;
                          modeName = exercises.first.modes.first.modeName;
                          break;
                        }
                      }
                    }

                    int exerciseId = exerciseForSub?.id ?? 0;
                    String level = modeName ?? '';
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.primaryColor2.withOpacity(0.3),
                            AppColors.primaryColor1.withOpacity(0.3)
                          ]),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subCategoryName,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${list.length} Exercises | ",
                                        style: TextStyle(
                                          color: AppColors.gray,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 16,
                                            color: AppColors.gray,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            _formatDuration(duration),
                                            style: TextStyle(
                                              color: AppColors.obesitysecond,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                      width: 100,
                                      height: 25,
                                      child: RoundButtonWorkout(
                                        title: "View more",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        onPressed: () {
                                          AppNavigator.push(
                                              context,
                                              ExerciseBySubCategoryView(
                                                subCategoryId: subCategoryId,
                                                level: level,
                                                image: subCategoryImage,
                                              ));
                                        },
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: SwitchImageType.buildImage(
                                exerciseSubCategory[subCategoryId].toString(),
                                width: 90,
                                height: 90,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }

          return Container();
        }));
  }
}

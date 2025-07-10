import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/profile/bloc/workout_progress_cubit.dart';
import 'package:projectflutter/presentation/profile/bloc/workout_progress_state.dart';
import 'package:projectflutter/presentation/profile/widgets/achievement_row.dart';

class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppBar(
          hideBack: false,
          title: Text(
            "Achievement",
            style: TextStyle(
                fontSize: AppFontSize.titleAppBar(context),
                fontWeight: FontWeight.w700),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => WorkoutProgressCubit()..displayProgress(),
              ),
              BlocProvider(
                create: (context) => ExercisesCubit()..listExercise(),
              )
            ],
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
                final exerciseList = state.entity;


                return BlocBuilder<WorkoutProgressCubit, WorkoutProgressState>(
                    builder: (context, state) {
                  if (state is WorkoutProgressLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is LoadWorkoutProgressFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }
                  if (state is WorkoutProgressLoaded) {
                    final progressList = state.listProgress;
                    Map<String, List<ExerciseProgressEntity>>
                        groupedSubCategoryResetBatch = {};
                    Map<int, Map<String, dynamic>> countExercise = {};
                    for (var e in progressList) {
                      final key = '${e.session!.subCategory!.id}-${e.session!.resetBatch}';
                      groupedSubCategoryResetBatch[key] ??= [];
                      groupedSubCategoryResetBatch[key]!.add(e);
                    }
                    for (var exercise in exerciseList) {
                      for (var sub in exercise.subCategory) {
                        final subCategoryId = sub.id;

                        if (!countExercise.containsKey(subCategoryId)) {
                          countExercise[subCategoryId] = {
                            'subCategory': sub,
                            'exercises': <ExercisesEntity>[],
                          };
                        }
                        countExercise[subCategoryId]!['exercises'].add(exercise);
                      }
                    }

                    Map<int, int> countExerciseNumber = {};
                    Map<int, double> kcalPerSubcategory = {};

                    countExercise.forEach((subCategoryId, value) {
                      final exercises = value['exercises'] as List<ExercisesEntity>;
                      countExerciseNumber[subCategoryId] = exercises.length;
                      final totalKcal = exercises.fold(
                          0.0, (sum, item) => sum += item.kcal);
                      kcalPerSubcategory[subCategoryId] = totalKcal;
                    });

                    Map<int, double> percentPerSubcategory = {};
                    countExercise.forEach((subCategoryId, value) {
                      final subCategory = value['subCategory'] as dynamic;
                      final subCategoryName = subCategory.subCategoryName;
                      final totalExercise = countExerciseNumber[subCategoryId]!;

                      final groupProgressList = groupedSubCategoryResetBatch.entries
                          .where((e) => e.key.startsWith('$subCategoryId-'))
                          .expand((e) => e.value)
                          .toList();

                      final completedCount = groupProgressList.length;

                      final percent = totalExercise == 0.0 ? 0.0 : completedCount / totalExercise;
                      percentPerSubcategory[subCategoryId] = percent;
                    });
                    final sortedEntries = countExercise.entries.toList()
                      ..sort((a, b) => a.key.compareTo(b.key));
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: sortedEntries.map((entry) {
                              final subCategoryId = entry.key;
                              final data = entry.value;
                              final subCategory = data['subCategory'];
                              final subCategoryName = subCategory.subCategoryName;
                              final subCategoryImage = subCategory.subCategoryImage;
                              final totalExercise = countExerciseNumber[subCategoryId]!;
                              final percent = percentPerSubcategory[subCategoryId]!;
                              final kcal = kcalPerSubcategory[subCategoryId]!;
                              return AchievementRow(
                                  image: (subCategoryImage == '' ||
                                          subCategoryImage.isEmpty)
                                      ? exerciseSubCategory[subCategoryId]
                                          .toString()
                                      : subCategoryImage,
                                  name: subCategoryName,
                                  kcal: kcal,
                                  percent: percent,
                                  totalExercise: totalExercise);
                            }).toList(),
                          ),
                        ));
                  }
                  return Container();
                });
              }
              return Container();
            })));
  }
}

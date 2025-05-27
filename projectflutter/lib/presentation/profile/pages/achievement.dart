import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
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
          title: const Text(
            "Achievement",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.backgroundColor,
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
                Map<String, List<ExercisesEntity>> countExercise = {};
                for (var exercise in exerciseList) {
                  final subCategoryName = exercise.subCategory!.subCategoryName;
                  countExercise
                      .putIfAbsent(subCategoryName, () => [])
                      .add(exercise);
                }
                Map<String, int> countExerciseNumber = {};
                countExercise.forEach((subCategoryName, exercises) {
                  countExerciseNumber[subCategoryName] = exercises.length;
                });

                Map<String, double> kcalPerSubcategory = {};
                countExercise.forEach((subCategoryName, exercises) {
                  double totalKcal =
                      exercises.fold(0.0, (sum, item) => sum += item.kcal);
                  kcalPerSubcategory[subCategoryName] = totalKcal;
                });

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
                    for (var progress in state.listProgress) {
                      final subCategoryName = progress
                          .exercise!.exercise!.subCategory!.subCategoryName;
                      final resetBatch = progress.exercise!.resetBatch;
                      if(resetBatch == 0){
                        final key = '$subCategoryName-$resetBatch';
                        groupedSubCategoryResetBatch
                            .putIfAbsent(key, () => [])
                            .add(progress);
                      }

                    }
                    Map<String, double> percentPerSubcategory = {};
                    for (var entry in countExercise.entries) {
                      final subCategoryName = entry.key;
                      final totalExercise = countExerciseNumber[subCategoryName]!;
                      final groupProgressList = groupedSubCategoryResetBatch.entries
                          .where((e) => e.key.startsWith('$subCategoryName-'))
                          .expand((e) => e.value)
                          .toList();

                      final completedCount = groupProgressList.length;

                      final percent = completedCount / totalExercise;
                      percentPerSubcategory[subCategoryName] = percent;
                    }

                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: countExercise.entries.map((entry) {
                              final list = entry.value;
                              var subCategoryId = list.first.subCategory!.id;
                              var subCategoryImage =
                                  list.first.subCategory!.subCategoryImage;
                              var subCategoryName =
                                  list.first.subCategory!.subCategoryName;

                              var totalExercise =
                                  countExerciseNumber[subCategoryName]!;
                              var percent = percentPerSubcategory[subCategoryName]!;
                              return AchievementRow(
                                  image: (subCategoryImage == '' ||
                                          subCategoryImage.isEmpty)
                                      ? exerciseSubCategory[subCategoryId]
                                          .toString()
                                      : subCategoryImage,
                                  name: subCategoryName,
                                  kcal: kcalPerSubcategory[subCategoryName]!,
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

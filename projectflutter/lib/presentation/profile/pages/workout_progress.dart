import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/workout/workout_row.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_result.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_start.dart';
import 'package:projectflutter/presentation/profile/bloc/workout_progress_cubit.dart';
import 'package:projectflutter/presentation/profile/bloc/workout_progress_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProgressPage extends StatelessWidget {
  const WorkoutProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BasicAppBar(
        hideBack: false,
        title: const Text(
          "Latest Workout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        onPressed: (){
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
          ),
          BlocProvider(create: (context) => ButtonExerciseCubit())
        ],
        child: BlocBuilder<ExercisesCubit, ExercisesState>(
          builder: (context, exerciseState) {
            if (exerciseState is ExercisesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (exerciseState is LoadExercisesFailure) {
              return Center(child: Text(exerciseState.errorMessage));
            }

            if (exerciseState is ExercisesLoaded) {
              final exerciseList = exerciseState.entity;

              final Map<String, Set<int>> uniqueExercisesSubPerCategory = {};
              for (var e in exerciseList) {
                final subCategoryName = e.subCategory!.subCategoryName;
                uniqueExercisesSubPerCategory
                    .putIfAbsent(subCategoryName, () => {})
                    .add(e.id);
              }

              return BlocBuilder<WorkoutProgressCubit, WorkoutProgressState>(
                builder: (context, state) {
                  if (state is WorkoutProgressLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is LoadWorkoutProgressFailure) {
                    return Center(child: Text(state.errorMessage));
                  }

                  if (state is WorkoutProgressLoaded) {
                    Map<String, List<ExerciseProgressEntity>>
                        groupedSubCategoryResetBatch = {};
                    for (var progress in state.listProgress) {
                      final subCategoryName = progress
                          .exercise!.exercise!.subCategory!.subCategoryName;
                      final resetBatch = progress.exercise!.resetBatch;
                      final key = '$subCategoryName-$resetBatch';
                      groupedSubCategoryResetBatch
                          .putIfAbsent(key, () => [])
                          .add(progress);
                    }

                    final sortedEntries =
                        groupedSubCategoryResetBatch.entries.toList()
                          ..sort((a, b) {
                            final aUpdated = getLatestUpdated(a.value);
                            final bUpdated = getLatestUpdated(b.value);
                            if (aUpdated == null && bUpdated == null) return 0;
                            if (aUpdated == null) return 1;
                            if (bUpdated == null) return -1;
                            return bUpdated.compareTo(aUpdated);
                          });

                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:  const EdgeInsets.only(bottom: 8, left: 10, right: 10),
                          child: Column(
                            children: sortedEntries.map((entry) {
                              final list = entry.value;
                              var duration = (list.fold(0, (sum,item) => sum += item.exercise!.exercise!.duration) / 60).floor();
                              var subCategoryImage = list.first.exercise!
                                  .exercise!.subCategory!.subCategoryImage;
                              var subCategoryName = list.first.exercise!.exercise!
                                  .subCategory!.subCategoryName;
                              var subCategoryId =
                                  list.first.exercise!.exercise!.subCategory!.id;
                              var completed = list.length;
                              var total =
                                  uniqueExercisesSubPerCategory[subCategoryName]
                                          ?.length ??
                                      0;
                              var progressRatio =
                                  total > 0 ? completed / total : 0.0;
                              var totalKcal = list.fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item.exercise?.kcal ?? 0));

                              return Builder(builder: (context) {
                                return WorkoutRow(
                                    image: subCategoryImage == ''
                                        ? exerciseSubCategory[subCategoryId]
                                            .toString()
                                        : subCategoryImage,
                                    name: subCategoryName,
                                    duration: duration,
                                    progress: progressRatio,
                                    kcal: totalKcal,
                                    onPressed: () async {
                                      if (progressRatio * 100 < 100) {
                                        final prefs = await SharedPreferences.getInstance();
                                        prefs.setBool('overlay', true);
                                        var shouldContinue =
                                            await ShowDialog.shouldContinue(
                                                context,
                                                'Continue?',
                                                'Are you sure want to continue?');
                                        if (shouldContinue == true) {
                                          final filteredExercises = exerciseList
                                              .where((e) =>
                                                  e.subCategory!.id ==
                                                  subCategoryId)
                                              .toList();
                                          var currentIndex = await context
                                              .read<ButtonExerciseCubit>()
                                              .getNextExerciseIndex(
                                                  filteredExercises);
                                          if (context.mounted &&
                                              currentIndex != null) {
                                            AppNavigator.push(
                                              context,
                                              ExerciseStart(
                                                  exercises: filteredExercises,
                                                  currentIndex: currentIndex),
                                            );
                                          }
                                        }
                                      } else {
                                        var shouldContinue =
                                            await ShowDialog.shouldContinue(
                                                context,
                                                'Continue?',
                                                'Are you sure want to move result?');
                                        if (shouldContinue == true) {
                                          if (context.mounted) {
                                            AppNavigator.push(
                                              context,
                                              const ExerciseResultPage(),
                                            );
                                          }
                                        }
                                      }
                                    });
                              });
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  }

                  return Container();
                },
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

DateTime? getLatestUpdated(List<ExerciseProgressEntity> list) {
  return list
      .map((e) => e.lastUpdated)
      .whereType<DateTime>()
      .fold<DateTime?>(null, (prev, curr) {
    if (prev == null || curr.isAfter(prev)) return curr;
    return prev;
  });
}

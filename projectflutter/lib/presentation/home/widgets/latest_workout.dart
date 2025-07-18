import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/workout/workout_row.dart';
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

class LatestWorkout extends StatelessWidget {
  const LatestWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
              for(var sub in e.subCategory){
                final subCategoryName = sub.subCategoryName;
                uniqueExercisesSubPerCategory
                    .putIfAbsent(subCategoryName, () => {})
                    .add(e.id);
              }

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
                  final progress = state.listProgress;
                  if (progress.isEmpty) {
                    return const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text('No recent workouts available'),
                        ));
                  }
                  Map<String, List<ExerciseProgressEntity>>
                      groupedSubCategoryResetBatch = {};
                  for (var progress in state.listProgress) {
                    final session = progress.session;
                    if (session != null &&
                        session.subCategory != null) {
                      final subCategoryId = session.subCategory!.id;
                      final resetBatch = session.resetBatch;
                      final key = '$subCategoryId-$resetBatch';

                      groupedSubCategoryResetBatch
                          .putIfAbsent(key, () => [])
                          .add(progress);
                    }

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
                      child: Column(
                        children: sortedEntries.take(2).map((entry) {
                          final list = entry.value;
                          var duration = (list.fold(
                              0,
                                  (sum, item) => sum += item
                                  .session!.exercise!.duration))
                              .floor();
                          final firstSub = list.first;
                          final subCategoryOfSession = firstSub.session!.subCategory;

                          var subCategoryImage = subCategoryOfSession!.subCategoryImage;
                          var subCategoryName = subCategoryOfSession.subCategoryName;
                          var subCategoryId = subCategoryOfSession.id;

                          var completed = list.length;
                          var totalExercise =
                              uniqueExercisesSubPerCategory[subCategoryName]
                                      ?.length ??
                                  0;
                          var resetBatch = list.last.session!.resetBatch;
                          var progressRatio =
                          totalExercise > 0 ? completed / totalExercise : 0.0;
                          var totalKcal = list.fold<double>(0,
                              (sum, item) => sum + (item.session?.kcal ?? 0));

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
                                  if (progressRatio * 100 == 100) {

                                    var shouldContinue =
                                        await ShowDialog.shouldContinue(
                                            context,
                                            'Continue?',
                                            'Are you sure want to move result?');
                                    if (shouldContinue == true) {
                                      if (context.mounted) {
                                        AppNavigator.push(
                                          context,
                                           ExerciseResultPage(
                                              resetBatch: resetBatch,
                                              totalExercise: totalExercise,
                                              kcal: totalKcal,
                                              duration: duration),
                                        );
                                      }
                                    }
                                  }
                                }
                            );
                          });
                        }).toList(),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_sub_category_list_by_goal.dart';

class ExerciseSearchByGoal extends StatelessWidget {
  const ExerciseSearchByGoal({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ExerciseSubCategoryProgramCubit()..listSubCategoryProgram(),
        ),
        BlocProvider(
          create: (context) => ExerciseSubCategoryCubit()..listSubCategory(),
        ),
        BlocProvider(
          create: (context) => ExercisesCubit()..listExercise(),
        )
      ],
      child: BlocBuilder<ExerciseSubCategoryCubit, ExerciseSubCategoryState>(
        builder: (context, state) {
          if (state is SubCategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadSubCategoryFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is SubCategoryLoaded) {
            return BlocBuilder<ExercisesCubit, ExercisesState>(
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
                  Map<String, List<ExercisesEntity>> groupedSubCategory = {};
                  for (var exercise in exerciseList) {
                    for (var sub in exercise.subCategory) {
                      final subCategoryName = sub.subCategoryName;
                      groupedSubCategory
                          .putIfAbsent(subCategoryName, () => [])
                          .add(exercise);
                    }
                  }
                  Map<String, int> durationBySubCategory = {};
                  groupedSubCategory.forEach((subCatName, exercises) {
                    durationBySubCategory[subCatName] =
                        exercises.fold(0, (sum, item) => sum += item.duration);
                  });
                  return BlocBuilder<ExerciseSubCategoryProgramCubit,
                      ExerciseSubCategoryProgramState>(
                    builder: (context, state) {
                      if (state is LoadSubCategoryProgramFailure) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      if (state is SubCategoryProgramLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is SubCategoryProgramLoaded) {
                        final programs = state.entity;
                        List goals = [
                          'Lose Weight',
                          'Build Muscle',
                          'Keep Fit'
                        ];
                        final imageGoal = [
                          'assets/images/search_lose_weight.png',
                          'assets/images/search_build_muscle.png',
                          'assets/images/search_keep_fit.png'
                        ];
                        return SizedBox(
                          height: media.height * 0.18,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: goals.length,
                            itemBuilder: (context, index) {
                              final goal = goals[index];
                              return GestureDetector(
                                onTap: () {
                                  final filteredList = programs
                                      .where(
                                          (e) => e.program!.programName == goal)
                                      .toList();
                                  final subCategoryIds = filteredList
                                      .where((e) => e.subCategory != null)
                                      .map((e) => e.subCategory!.id)
                                      .toSet();
                                  final modeBySubCategoryId = extractModesBySubCategoryId(
                                    exercises: exerciseList,
                                    subCategoryFilterIds: subCategoryIds,
                                  );

                                  final Map<int, String> levelBySubCategoryId = {};
                                  const ordered = ['Beginner', 'Intermediate', 'Advanced', 'Stretch'];

                                  for (final subId in subCategoryIds) {
                                    final modes = modeBySubCategoryId[subId];
                                    if (modes != null && modes.isNotEmpty) {
                                      levelBySubCategoryId[subId] = ordered.firstWhere(
                                            (m) => modes.contains(m),
                                        orElse: () => modes.first,
                                      );
                                    }
                                  }

                                  int exerciseId = 0;
                                  for (final exercise in exerciseList) {
                                    if (exercise.subCategory.any((sub) => subCategoryIds.contains(sub.id))) {
                                      exerciseId = exercise.id;
                                      break;
                                    }
                                  }
                                  AppNavigator.push(
                                      context,
                                      ExerciseSubCategoryListByGoalPage(
                                          categoryName: goal,
                                          level: levelBySubCategoryId,
                                          exerciseId: exerciseId,
                                          duration: durationBySubCategory,
                                          total: filteredList));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  width: media.width * 0.5,
                                  height: media.height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color:
                                            AppColors.black.withOpacity(0.25)),
                                    color: const Color(0xff3674B5)
                                        .withOpacity(0.6),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SwitchImageType.buildImage(
                                        imageGoal[index % imageGoal.length],
                                        width: media.width * 0.5,
                                        height: media.height * 0.1,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        goal,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              AppFontSize.value22Text(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                    },
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
  Map<int, Set<String>> extractModesBySubCategoryId({
    required List<ExercisesEntity> exercises,
    required Set<int> subCategoryFilterIds,
  }) {
    final Map<int, Set<String>> result = {};

    for (final exercise in exercises) {
      if (exercise.subCategory.length == 1) {
        final sub = exercise.subCategory.first;

        if (subCategoryFilterIds.contains(sub.id)) {
          result.putIfAbsent(sub.id, () => <String>{});
          result[sub.id]!.addAll(exercise.modes.map((m) => m.modeName));
        }
      }
    }

    return result;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_new_category.dart';

import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_popular_list.dart';

class ExerciseListCategoryPopular extends StatelessWidget {
  const ExerciseListCategoryPopular({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ExerciseSubCategoryProgramCubit()..listSubCategoryProgram(),
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
              final listExercise = state.entity;
              return BlocBuilder<ExerciseSubCategoryProgramCubit,
                  ExerciseSubCategoryProgramState>(
                builder: (context, state) {
                  if (state is SubCategoryProgramLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is LoadSubCategoryProgramFailure) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }
                  if (state is SubCategoryProgramLoaded) {
                    final Map<int, String> subCategoryIdToProgramName = {};
                    for (var sub in state.entity) {
                      if (sub.subCategory != null && sub.program != null) {
                        subCategoryIdToProgramName[sub.subCategory!.id] =
                            sub.program!.programName;
                      }
                    }
                    final groupedSubCategoryByPopular =
                        groupSubCategoriesByCategoryList(
                            state.entity, newCategory);
                    final durationBySubCategory = <String, int>{};
                    for (var exercise in listExercise) {
                      for (var sub in exercise.subCategory) {
                        final subCategoryName = sub.subCategoryName.trim();
                        durationBySubCategory[subCategoryName] =
                            (durationBySubCategory[subCategoryName] ?? 0) +
                                exercise.duration;
                      }
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: groupedSubCategoryByPopular.entries.map((entry) {
                          final categoryName = entry.key;
                          final subList = entry.value;
                          final Map<int, Set<String>> modeBySubCategoryId = {};

                          for (final exercise in listExercise) {
                            if (exercise.subCategory.length == 1) {
                              final modeNames = exercise.modes.map((m) => m.modeName.toLowerCase());
                              for (final sub in exercise.subCategory) {
                                modeBySubCategoryId.putIfAbsent(sub.id, () => {});
                                modeBySubCategoryId[sub.id]!.addAll(modeNames);
                              }
                            }
                          }

                          final Map<int, String> levelBySubCategoryId = {};
                          const ordered = ['Beginner', 'Intermediate', 'Advanced', 'Stretch'];

                          for (final entry in modeBySubCategoryId.entries) {
                            final modes = entry.value;
                            if (modes.isNotEmpty) {
                              levelBySubCategoryId[entry.key] = ordered.firstWhere(
                                    (m) => modes.contains(m.toLowerCase()),
                                orElse: () => modes.first,
                              );
                            }
                          }
                          final Map<String, List<ExercisesEntity>> groupedExercises = {};

                          for (var exercise in listExercise) {
                            if (exercise.modes == null) continue;
                            for (var sub in exercise.subCategory) {
                              final key = '${sub.id}-${exercise.modes.first.id}';
                              groupedExercises
                                  .putIfAbsent(key, () => [])
                                  .add(exercise);
                            }
                          }

                          final List<(ExerciseSubCategoryProgramEntity, String)> finalListWithLevel = [];

                          for (var e in subList) {
                            final subCategoryId = e.subCategory?.id;
                            if (subCategoryId == null) continue;

                            final relatedExercises = listExercise.where(
                                  (ex) => ex.subCategory.any((s) => s.id == subCategoryId),
                            ).toList();

                            if (relatedExercises.isEmpty) continue;

                            final modeName = levelBySubCategoryId[subCategoryId] ?? 'Unknown';

                            finalListWithLevel.add((e, modeName));
                          }

                          if (finalListWithLevel.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ExercisePopularList(
                              categoryName: categoryName,
                              onPressed: (e) {
                                final level = finalListWithLevel.firstWhere((pair) => pair.$1 == e).$2;
                                AppNavigator.push(
                                  context,
                                  ExerciseBySubCategoryView(
                                    subCategoryId: e.subCategory!.id,
                                    level: level,
                                    image: e.subCategory!.subCategoryImage,
                                  ),
                                );
                              },
                              duration: durationBySubCategory,
                              list: finalListWithLevel,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ));
  }

  Map<String, List<ExerciseSubCategoryProgramEntity>>
      groupSubCategoriesByCategoryList(
    List<ExerciseSubCategoryProgramEntity> allSubs,
    List<String> categoryList,
  ) {
    final Map<String, List<ExerciseSubCategoryProgramEntity>> grouped = {
      for (var name in categoryList) name: []
    };

    for (var sub in allSubs) {
      final programName = sub.program?.programName.trim();
      if (programName != null && categoryList.contains(programName)) {
        grouped[programName]!.add(sub);
      }
    }

    return grouped;
  }
}

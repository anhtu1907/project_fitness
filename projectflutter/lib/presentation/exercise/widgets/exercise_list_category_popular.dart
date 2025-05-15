import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_new_category.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_popular_list.dart';

class ExerciseListCategoryPopular extends StatelessWidget {
  const ExerciseListCategoryPopular({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExerciseSubCategoryCubit()..listSubCategory(),
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
              Map<String, List<ExercisesEntity>> groupedPrograming = {};
              for (var exercise in listExercise) {
                final subCategoryName = exercise.subCategory!.subCategoryName;
                if (specialSubCategoryNames.contains(subCategoryName)) {
                  groupedPrograming
                      .putIfAbsent(subCategoryName, () => [])
                      .add(exercise);
                }
              }

              Map<String, List<ExercisesEntity>> groupedSubCategory = {};
              for (var exercise in listExercise) {
                final subCategoryName = exercise.subCategory!.subCategoryName;
                groupedSubCategory
                    .putIfAbsent(subCategoryName, () => [])
                    .add(exercise);
              }

              return BlocBuilder<ExerciseSubCategoryCubit,
                  ExerciseSubCategoryState>(
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
                    final groupedSubCategoryByPopular =
                        groupSubCategoriesByCategoryMap(
                            state.entity, newCategory, listExercise);
                    final durationBySubCategory = <String, int>{};
                    for (var exercise in listExercise) {
                      final subCategoryName =
                          exercise.subCategory?.subCategoryName;
                      if (subCategoryName != null) {
                        durationBySubCategory[subCategoryName] =
                            (durationBySubCategory[subCategoryName] ?? 0) +
                                exercise.duration;
                      }
                    }

                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: groupedSubCategoryByPopular.entries
                                .map((entry) {
                          final categoryName = entry.key;
                          final subList = entry.value;
                          if (subList.isEmpty) return const SizedBox();

                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ExercisePopularList(
                                categoryName: categoryName,
                                onPressed: (e) {
                                  AppNavigator.push(
                                      context,
                                      ExerciseBySubCategoryView(
                                          subCategoryId: e.id));
                                },
                                duration: durationBySubCategory,
                                list: subList),
                          );
                        }).toList()));
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ));
  }

  Map<String, List<ExerciseSubCategoryEntity>> groupSubCategoriesByCategoryMap(
    List<ExerciseSubCategoryEntity> allSubs,
    Map<String, List<String>> categoryMap,
    List<ExercisesEntity> exercises,
  ) {
    final Map<String, int> durationBySubCategory = {};

    for (var exercise in exercises) {
      final subCategoryName = exercise.subCategory?.subCategoryName;
      if (subCategoryName != null) {
        durationBySubCategory[subCategoryName] =
            (durationBySubCategory[subCategoryName] ?? 0) + exercise.duration;
      }
    }

    final Map<String, List<ExerciseSubCategoryEntity>> grouped = {
      for (var key in categoryMap.keys) key: []
    };

    for (var sub in allSubs) {
      final subCategoryName = sub.subCategoryName;

      for (final entry in categoryMap.entries) {
        if (entry.value.contains(subCategoryName)) {
          grouped[entry.key]!.add(sub);
        }
      }
    }

    return grouped;
  }
}

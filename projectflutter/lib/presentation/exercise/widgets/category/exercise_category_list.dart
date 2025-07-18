import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/widgets/category/exercise_category_item.dart';

class ExerciseCategoryList extends StatelessWidget {
  const ExerciseCategoryList({super.key});

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
            final subCategoryList = state.entity;
            Map<String, List<ExerciseSubCategoryEntity>> groupedCategory = {};

            for (var subCategory in subCategoryList) {
              for (var cat in subCategory.category) {
                final categoryName = cat.categoryName;
                groupedCategory.putIfAbsent(categoryName, () => []);
                if (!groupedCategory[categoryName]!
                    .any((item) => item.id == subCategory.id)) {
                  groupedCategory[categoryName]!.add(subCategory);

                }
              }
            }
            final groupedList = groupedCategory.entries.toList();
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
                  Map<int, Set<String>> modeBySubCategoryId = {};
                  Map<String, List<ExercisesEntity>> groupedSubCategory = {};
                  for (var exercise in exerciseList) {
                    for (var sub in exercise.subCategory) {
                      if (exercise.subCategory.length == 1) {
                        modeBySubCategoryId.putIfAbsent(sub.id, () => {});
                        modeBySubCategoryId[sub.id]!.addAll(
                          exercise.modes.map((mode) => mode.modeName),
                        );
                      }
                      for (var sub in exercise.subCategory) {
                        final subCategoryName = sub.subCategoryName;
                        groupedSubCategory.putIfAbsent(subCategoryName, () => []).add(exercise);
                      }
                    }
                  }
                  Map<int, int> durationBySubCategoryId = {};

                  for (var exercise in exerciseList) {
                    for (var sub in exercise.subCategory) {
                      durationBySubCategoryId[sub.id] =
                          (durationBySubCategoryId[sub.id] ?? 0) + exercise.duration;
                    }
                  }
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: groupedList.length,
                    itemBuilder: (context, index) {
                      final entry = groupedList[index];
                      Map<int, String> levelBySubCategoryId = {};
                      for (var sub in entry.value) {
                        final modes = modeBySubCategoryId[sub.id];
                        if (modes != null && modes.isNotEmpty) {
                          final ordered = ["Beginner", "Intermediate", "Advanced", "Stretch"];
                          final sorted = ordered.firstWhere(
                                (m) => modes.contains(m),
                            orElse: () => modes.first,
                          );
                          levelBySubCategoryId[sub.id] = sorted;
                        }
                      }
                      return ExerciseCategoryItem(
                        total: entry.value,
                        categoryName:entry.key,
                        level: levelBySubCategoryId,
                        duration: durationBySubCategoryId,
                      );
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
}

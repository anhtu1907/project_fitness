import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_category_item.dart';

class ExerciseCategoryList extends StatelessWidget {
  const ExerciseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

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
            for (var category in subCategoryList) {
              final categoryName = category.category!.categoryName;
              groupedCategory.putIfAbsent(categoryName, () => []).add(category);
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
                  Map<String, List<ExercisesEntity>> groupedSubCategory = {};
                  for (var exercise in exerciseList) {
                    final subCategoryName =
                        exercise.subCategory!.subCategoryName;
                    groupedSubCategory
                        .putIfAbsent(subCategoryName, () => [])
                        .add(exercise);
                  }
                  Map<String, int> durationBySubCategory = {};
                  groupedSubCategory.forEach((subCatName, exercises) {
                    durationBySubCategory[subCatName] =
                        exercises.fold(0, (sum, item) => sum += item.duration);
                  });
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: groupedList.length,
                    itemBuilder: (context, index) {
                      final entry = groupedList[index];
                      return ExerciseCategoryItem(
                        total: entry.value,
                        duration: durationBySubCategory,
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

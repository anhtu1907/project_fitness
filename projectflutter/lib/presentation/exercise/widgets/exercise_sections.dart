import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/data/exercise_new_category.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_new_category.dart';

class ExerciseSections extends StatelessWidget {
  const ExerciseSections({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
            // Map<String, List<ExercisesEntity>> groupedPrograming = {};
            // for (var exercise in listExercise) {
            //   final subCategoryName = exercise.subCategory!.subCategoryName;
            //   if (specialSubCategoryNames.contains(subCategoryName)) {
            //     groupedPrograming
            //         .putIfAbsent(subCategoryName, () => [])
            //         .add(exercise);
            //   }
            final groupedPrograming = groupExercisesBySpecialSubCategory(
                listExercise, specialSubCategoryNames);

            return BlocBuilder<ExerciseSubCategoryCubit,
                ExerciseSubCategoryState>(builder: (context, state) {
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
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programing Exercises',
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listExerciseByCategory(context, groupedPrograming),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        'Fresh Morning',
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        'With Equipment',
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        'HIIT Workout',
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            });
          }
          return Container();
        }));
  }

  Widget _listExerciseByCategory(
      BuildContext context, Map<String, List<ExercisesEntity>> grouped) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: grouped.entries.length,
        itemBuilder: (context, index) {
          final entry = grouped.entries.elementAt(index);
          return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ExerciseNewCategory(
                name: entry.key,
                subCategoryId: entry.value.first.subCategory!.id,
                subName: entry.value.first.subCategory!.description,
              ));
        },
      ),
    );
  }

  Map<String, List<ExercisesEntity>> groupExercisesBySpecialSubCategory(
    List<ExercisesEntity> exercises,
    Set<String> specialSubCategoryNames,
  ) {
    final Map<String, List<ExercisesEntity>> grouped = {};

    for (var exercise in exercises) {
      final subCategoryName = exercise.subCategory?.subCategoryName;
      if (subCategoryName != null &&
          specialSubCategoryNames.contains(subCategoryName)) {
        grouped.putIfAbsent(subCategoryName, () => []).add(exercise);
      }
    }

    return grouped;
  }
}

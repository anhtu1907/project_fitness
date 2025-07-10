import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_new_category.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_program_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_card.dart';

class ExerciseSections extends StatelessWidget {
  const ExerciseSections({super.key});

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
                ExerciseSubCategoryProgramState>(builder: (context, state) {
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
                final subCategoryProgram = state.entity;
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleRow(context, 'Fresh Morning', durationBySubCategory,
                          subCategoryProgram, 'Fresh Morning',exerciseList),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listExerciseByProgram(context, subCategoryProgram,
                          'Fresh Morning', exerciseList),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _titleRow(
                          context,
                          'With Equipment',
                          durationBySubCategory,
                          subCategoryProgram,
                          'With Equipment',exerciseList),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listExerciseByProgram(context, subCategoryProgram,
                          'With Equipment', exerciseList),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _titleRow(context, 'HIIT Workout', durationBySubCategory,
                          subCategoryProgram, 'HIIT Workout',exerciseList),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listExerciseByProgram(context, subCategoryProgram,
                          'HIIT Workout', exerciseList),
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

  Widget _listExerciseByProgram(
      BuildContext context,
      List<ExerciseSubCategoryProgramEntity> allItems,
      String programName,
      List<ExercisesEntity> exerciseList) {
    final normalizedName = programName.toLowerCase().trim();
    final List<ExerciseSubCategoryProgramEntity> items = allItems
        .where((e) =>
            e.program?.programName.toLowerCase().trim() == normalizedName)
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final subCategoryId = item.subCategory!.id;
          final durationAndTotal = getDurationAndTotalExerciseOfSubCategory(subCategoryId, exerciseList);
          String? levelName;

          for (var ex in exerciseList) {
            if (ex.subCategory.any((sub) => sub.id == subCategoryId)) {
              levelName = ex.mode?.modeName;
              break;
            }
          }
          return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ExerciseSubCategoryCard(
                name: item.subCategory!.subCategoryName,
                subCategoryId: subCategoryId,
                level: levelName!,
                duration: durationAndTotal['duration']!,
                totalWorkout: durationAndTotal['totalWorkout']!,
                subName: item.subCategory!.description,
                image: item.subCategory!.subCategoryImage,
              ));
        },
      ),
    );
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

  Map<String, int> getDurationAndTotalExerciseOfSubCategory(
      int subCategoryId, List<ExercisesEntity> exerciseList) {
    int totalDuration = 0;
    int totalWorkout = 0;

    for (var exercise in exerciseList) {
      if (exercise.subCategory.any((sub) => sub.id == subCategoryId)) {
        totalDuration += exercise.duration;
        totalWorkout++;
      }
    }

    return {
      'duration': totalDuration,
      'totalWorkout': totalWorkout,
    };
  }

  Widget _titleRow(
      BuildContext context,
      String title,
      Map<String, int> durationBySubCategory,
      List<ExerciseSubCategoryProgramEntity> subCategoryProgram,
      String categoryName,
      List<ExercisesEntity> exerciseList) {
    final filteredList = subCategoryProgram
        .where((e) =>
            e.program?.programName.toLowerCase().trim() ==
            categoryName.toLowerCase().trim())
        .toList();
    int? subCategoryId;
    String? level;
    if (filteredList.isNotEmpty) {
      subCategoryId = filteredList.first.subCategory?.id;
    }

    if (subCategoryId != null) {
      for (var ex in exerciseList) {
        if (ex.subCategory.any((sub) => sub.id == subCategoryId)) {
          level = ex.mode?.modeName;
          break;
        }
      }
    }
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.value16Text(context),
              fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              AppNavigator.push(
                  context,
                  ExerciseSubCategoryProgramListPage(
                      categoryName: categoryName,
                      duration: durationBySubCategory,
                      level: level!,
                      total: filteredList));
            },
            child: Text(
              'See All',
              style:
                  TextStyle(color: AppColors.primaryColor1, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}

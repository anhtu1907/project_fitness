import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_mode_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_mode_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_sub_category_list_by_level.dart';

class ExerciseSearchByLevel extends StatelessWidget {
  const ExerciseSearchByLevel({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExerciseModeCubit()..listExerciseMode(),
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
            final subCategoryList = state.entity;
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
                  return BlocBuilder<ExerciseModeCubit, ExerciseModeState>(
                    builder: (context, state) {
                      if (state is LoadExerciseModeFailure) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      if (state is ExerciseModeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is ExerciseModeLoaded) {
                        final modes = state.entity;
                        return SizedBox(
                          height: media.height * 0.055,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: modes.length,
                            itemBuilder: (context, index) {
                              final mode = modes[index];
                              return GestureDetector(
                                onTap: () {
                                  final filteredList = exerciseList
                                      .where((e) =>
                                          e.mode!.modeName == mode.modeName)
                                      .toList();
                                  final List<ExerciseSubCategoryEntity> total = [];
                                  final level = mode.modeName;
                                  for (var exercise in filteredList) {
                                    for (var sub in exercise.subCategory) {
                                      final entity = subCategoryList.firstWhere(
                                            (e) => e.id == sub.id
                                      );
                                      if (!total.contains(entity)) {
                                        total.add(entity);
                                      }
                                    }
                                  }
                                  AppNavigator.push(
                                      context,
                                      ExerciseSubCategoryListByLevelPage(
                                          categoryName: mode.modeName,
                                          duration: durationBySubCategory,
                                          total: total,
                                          level: level,
                                          modeName: mode.modeName));
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.black.withOpacity(0.25)
                                      ),
                                      color: const Color(0xff555879)
                                          .withOpacity(0.4),
                                    ),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.menu,
                                            color: Colors.white,
                                          ),
                                           SizedBox(
                                            width: media.width * 0.02,
                                          ),
                                          Text(
                                            mode.modeName,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: AppFontSize.value14Text(context)),
                                          ),
                                        ],
                                      ),
                                    )),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/data/exercise/model/exercise_mode_model.dart';
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
                        final List<String> level = ['Beginner', 'Intermediate','Advanced'];
                        return SizedBox(
                          height: media.height * 0.055,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: level.length,
                            itemBuilder: (context, index) {
                              final mode = level[index];
                              return GestureDetector(
                                onTap: () {
                                  Map<int, Set<String>> modeBySubCategoryId = {};
                                  for (var exercise in exerciseList) {
                                    if (exercise.subCategory.length == 1) {
                                      for (var sub in exercise.subCategory) {
                                        modeBySubCategoryId.putIfAbsent(sub.id, () => {});
                                        modeBySubCategoryId[sub.id]!.addAll(
                                          exercise.modes.map((m) => m.modeName.toLowerCase()),
                                        );
                                      }
                                    }
                                  }

                                  final filteredSubCategories = subCategoryList.where((sub) {
                                    final modes = modeBySubCategoryId[sub.id];
                                    return modes != null && modes.contains(mode.toLowerCase());
                                  }).toList();

                                  final Map<String, int> durationBySubCategory = {};
                                  for (var sub in filteredSubCategories) {
                                    final exercisesInSub = exerciseList
                                        .where((e) => e.subCategory.any((s) => s.id == sub.id))
                                        .toList();
                                    final duration = exercisesInSub.fold(0, (sum, e) => sum + e.duration);
                                    durationBySubCategory[sub.subCategoryName] = duration;
                                  }

                                  final Map<int, String> levelBySubCategoryId = {};
                                  const ordered = ['Beginner', 'Intermediate', 'Advanced', 'Stretch'];
                                  for (final sub in filteredSubCategories) {
                                    final modesSet = modeBySubCategoryId[sub.id];
                                    if (modesSet != null && modesSet.isNotEmpty) {
                                      levelBySubCategoryId[sub.id] = ordered.firstWhere(
                                            (m) => modesSet.contains(m.toLowerCase()),
                                        orElse: () => modesSet.first,
                                      );
                                    }
                                  }

                                  AppNavigator.push(
                                      context,
                                      ExerciseSubCategoryListByLevelPage(
                                          categoryName: mode,
                                          duration: durationBySubCategory,
                                          total: filteredSubCategories,
                                          level: levelBySubCategoryId));
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
                                            mode,
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

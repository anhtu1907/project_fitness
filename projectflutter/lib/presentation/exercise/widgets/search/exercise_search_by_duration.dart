import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_sub_category_list_by_duration.dart';

class ExerciseSearchByDuration extends StatelessWidget {
  const ExerciseSearchByDuration({super.key});

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
                  List durations = ['1-7 min', '8-15 min', '>15 min'];
                  final durationRanges = {
                    '1-7 min': [60, 479],
                    '8-15 min': [480, 900],
                    '>15 min': [901, 99999],
                  };
                  const colors = [
                    Color(0xff537D5D),
                    Color(0xff0D5EA6),
                    Color(0xffE52020),
                  ];
                  Map<String, List<ExercisesEntity>> groupedSubCategory = {};
                  for (var exercise in exerciseList) {
                    for (var sub in exercise.subCategory) {
                      final subCategoryName = sub.subCategoryName;
                      groupedSubCategory
                          .putIfAbsent(subCategoryName, () => [])
                          .add(exercise);
                    }
                  }
                  Map<int, int> durationBySubCategoryId = {};
                  for (var exercise in exerciseList) {
                    for (var sub in exercise.subCategory) {
                      durationBySubCategoryId[sub.id] =
                          (durationBySubCategoryId[sub.id] ?? 0) + exercise.duration;
                    }
                  }
                  return SizedBox(
                    height: media.height * 0.12,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: durations.length,
                      itemBuilder: (context, index) {
                        final duration = durations[index];
                        return GestureDetector(
                          onTap: () {
                            final range = durationRanges[duration]!;
                            final minSeconds = range[0];
                            final maxSeconds = range[1];
                            final filteredList = subCategoryList.where((subCat) {
                              final subCatDuration = durationBySubCategoryId[subCat.id] ?? 0;
                              return subCatDuration >= minSeconds && subCatDuration <= maxSeconds;
                            }).toList();
                            final subCategoryIds =
                                filteredList.map((e) => e.id).toSet();

                            final relatedExercises = exerciseList
                                .where((ex) => ex.subCategory.any(
                                    (sub) => subCategoryIds.contains(sub.id)))
                                .toList();

                            final Map<int, Set<String>> modeBySubCategoryId = {};

                            for (final exercise in relatedExercises) {
                              if (exercise.subCategory.length == 1) {
                                final subId = exercise.subCategory.first.id;
                                if (subCategoryIds.contains(subId)) {
                                  modeBySubCategoryId.putIfAbsent(subId, () => {});
                                  modeBySubCategoryId[subId]!.addAll(exercise.modes.map((m) => m.modeName));
                                }
                              }
                            }

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
                            AppNavigator.push(
                                context,
                                ExerciseSubCategoryListByDurationPage(
                                    categoryName: duration,
                                    duration: durationBySubCategoryId,
                                    levelBySubCategoryId: levelBySubCategoryId,
                                    total: filteredList));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: media.width * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: colors[index % colors.length]
                                    .withOpacity(0.7),
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SwitchImageType.buildImage(
                                    AppImages.bgDots,
                                    height: media.width * 0.4,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.timer_sharp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: media.width * 0.01,
                                      ),
                                      Text(
                                        duration,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppFontSize.value16Text(
                                                context)),
                                      ),
                                    ],
                                  ),
                                ],
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
      ),
    );
  }
}

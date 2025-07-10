import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_search_page.dart';

class ExerciseSearchField extends StatefulWidget {
  const ExerciseSearchField({super.key});

  @override
  State<ExerciseSearchField> createState() => _ExerciseSearchFieldState();
}

class _ExerciseSearchFieldState extends State<ExerciseSearchField> {
  bool isFocused = false;

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
        builder: (context, exerciseState) {
          if (exerciseState is ExercisesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (exerciseState is LoadExercisesFailure) {
            return Center(
              child: Text(exerciseState.errorMessage),
            );
          }

          if (exerciseState is ExercisesLoaded) {
            final exerciseList = exerciseState.entity;

            /// Group exercise by sub category name
            Map<String, List<ExercisesEntity>> groupedSubCategory = {};
            for (var exercise in exerciseList) {
              for (var sub in exercise.subCategory) {
                final subCategoryName = sub.subCategoryName;
                groupedSubCategory
                    .putIfAbsent(subCategoryName, () => [])
                    .add(exercise);
              }
            }

            /// Sum duration by sub category
            Map<String, int> durationBySubCategory = {};
            groupedSubCategory.forEach((subCatName, exercises) {
              durationBySubCategory[subCatName] =
                  exercises.fold(0, (sum, item) => sum + item.duration);
            });

            return BlocBuilder<ExerciseSubCategoryCubit,
                ExerciseSubCategoryState>(
              builder: (context, subCategoryState) {
                if (subCategoryState is SubCategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (subCategoryState is LoadSubCategoryFailure) {
                  return Center(
                    child: Text(subCategoryState.errorMessage),
                  );
                }
                if (subCategoryState is SubCategoryLoaded) {
                  final subCategoryList = subCategoryState.entity;

                  /// Lấy level của exercise đầu tiên để truyền vào ExerciseSearchPage
                  final firstExercise = exerciseList.isNotEmpty
                      ? exerciseList.first
                      : null;
                  final level = firstExercise?.mode?.modeName ?? '';

                  return GestureDetector(
                    onTap: () {
                      AppNavigator.push(
                        context,
                        ExerciseSearchPage(
                          subCategoryList: subCategoryList,
                          level: level,
                          duration: durationBySubCategory,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          SizedBox(width: media.width * 0.02),
                          Text(
                            "Search by sub category...",
                            style: TextStyle(
                              fontSize: AppFontSize.body(context),
                            ),
                          ),
                        ],
                      ),
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

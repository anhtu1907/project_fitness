import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/suggest/setting_plan.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/exercise_plan_item.dart';

class PlanExercisePage extends StatefulWidget {
  const PlanExercisePage({super.key});

  @override
  State<PlanExercisePage> createState() => _PlanExercisePageState();
}

class _PlanExercisePageState extends State<PlanExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Plan Exercise',
              style: TextStyle(fontSize: AppFontSize.heading2(context))),
        ),
        action: IconButton(
            onPressed: () {
              AppNavigator.push(context, const SettingPlanPage());
            },
            icon: const Icon(Icons.tune)),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExerciseSubCategoryCubit()..listSubCategory(),
          ),
          BlocProvider(
            create: (context) => ExercisesCubit()..listExercise(),
          ),
          BlocProvider(
            create: (context) => ExerciseEquipmentCubit()..listExerciseEquipment(),
          ),
          BlocProvider(
            create: (context) => ExerciseSubCategoryProgramCubit()..listSubCategoryProgram(),
          ),
        ],
        child: BlocBuilder<ExerciseSubCategoryCubit, ExerciseSubCategoryState>(
          builder: (context, state) {
            if (state is SubCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadSubCategoryFailure) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is SubCategoryLoaded) {
              final listSubCategory = state.entity;
              return BlocBuilder<ExercisesCubit, ExercisesState>(
                builder: (context, exerciseState) {
                  if (exerciseState is ExercisesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (exerciseState is LoadExercisesFailure) {
                    return Center(child: Text(exerciseState.errorMessage));
                  }
                  if (exerciseState is ExercisesLoaded) {
                    final listExercise = exerciseState.entity;

                    // Grouping
                    Map<int, List<ExercisesEntity>> groupedSubCategory = {};
                    Map<int, int> durationBySubCategory = {};
                    Map<int, double> kcalBySubCategory = {};
                    for (var exercise in listExercise) {
                      for (var sub in exercise.subCategory) {
                        final subCategoryId = sub.id;
                        groupedSubCategory
                            .putIfAbsent(subCategoryId, () => [])
                            .add(exercise);
                      }
                    }
                    groupedSubCategory.forEach((subCategoryId, exercises) {
                      durationBySubCategory[subCategoryId] =
                          exercises.fold(0, (sum, item) => sum + item.duration);
                      kcalBySubCategory[subCategoryId] =
                          exercises.fold(0.0, (sum, item) => sum + item.kcal);
                    });

                    return ExercisePlanItem(
                      groupedSubCategory: groupedSubCategory,
                      durationBySubCategory: durationBySubCategory,
                      kcalBySubCategory: kcalBySubCategory,
                      subCategories: listSubCategory,
                    );
                  }
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

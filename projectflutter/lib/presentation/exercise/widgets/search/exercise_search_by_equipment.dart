import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/equipment_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/equipment_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_sub_category_list_by_equipment.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_equipment_item.dart';

class ExerciseSearchByEquipment extends StatelessWidget {
  const ExerciseSearchByEquipment({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EquipmentCubit()..listEquipment(),
        ),
        BlocProvider(
          create: (context) =>
              ExerciseEquipmentCubit()..listExerciseEquipment(),
        ),
        BlocProvider(
          create: (context) => ExercisesCubit()..listExercise(),
        )
      ],
      child: BlocBuilder<ExerciseEquipmentCubit, ExerciseEquipmentState>(
        builder: (context, state) {
          if (state is ExerciseEquipmentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadExerciseEquipmentFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is ExerciseEquipmentLoaded) {
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
                  return BlocBuilder<EquipmentCubit, EquipmentState>(
                    builder: (context, state) {
                      if (state is LoadEquipmentFailure) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      }
                      if (state is EquipmentLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is EquipmentLoaded) {
                        final equipments = state.entity;
                        return Wrap(
                          spacing: media.width * 0.04,
                          runSpacing: media.height * 0.015,
                          children: equipments.map((equipment) {
                            return GestureDetector(
                              onTap: () {
                                final filteredExercises = exerciseList
                                    .where((e) =>
                                        e.equipment?.equipmentName ==
                                        equipment.equipmentName)
                                    .toList();
                                final subCategories = <ExerciseSubCategoryModel>[];

                                for (final exercise in filteredExercises) {
                                  for (final sub in exercise.subCategory) {
                                    if (!subCategories.any((e) => e.id == sub.id)) {
                                      subCategories.add(sub);
                                    }
                                  }
                                }
                                final level = filteredExercises.isNotEmpty
                                    ? filteredExercises.first.mode?.modeName ?? ''
                                    : '';
                                AppNavigator.push(
                                  context,
                                  ExerciseSubCategoryListByEquipment(
                                    categoryName: equipment.equipmentName,
                                    duration: durationBySubCategory,
                                    level: level,
                                    total: subCategories.toList(),
                                  ),
                                );
                              },
                              child: ExerciseEquipmentItem(
                                image: equipment.equipmentImage,
                                equipmentName: equipment.equipmentName,
                              ),
                            );
                          }).toList(),
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

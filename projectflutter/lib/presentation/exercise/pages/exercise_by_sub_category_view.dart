import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/data/exercise/model/equipments_model.dart';
import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_by_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_by_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_state.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_button.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_details.dart';

class ExerciseBySubCategoryView extends StatelessWidget {
  final int subCategoryId;
  final String image;
  final String level;
  final bool markAsDayCompleted;
  final int? day;
  const ExerciseBySubCategoryView(
      {super.key,
      required this.subCategoryId,
      required this.image,
        this.day,
        this.markAsDayCompleted = false,
        required this.level});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExerciseBySubCategoryCubit()
              ..listExerciseBySubCategoryId(subCategoryId),
          ),
          BlocProvider(
            create: (context) =>
                ExerciseEquipmentCubit()..listAllEquipmentBySubId(subCategoryId),
          )
        ],
        child:
            BlocBuilder<ExerciseBySubCategoryCubit, ExerciseBySubCategoryState>(
          builder: (context, state) {
            if (state is ExerciseBySubCategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoadExerciseBySubCategoryFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            if (state is ExerciseBySubCategoryLoaded) {
              final exercises = state.entity;

              if (exercises.isEmpty) {
                return const Center(
                    child: Text('No exercises found for this sub-category.'));
              }
              final sub = state.entity.first.subCategory.first;

              final subCategoryName = sub.subCategoryName;
              final description = sub.description;
              final totalDuration = state.entity
                  .fold<int>(0, (sum, item) => sum += item.duration);
              final kcal =
                  state.entity.fold<double>(0, (sum, item) => sum += item.kcal);
              return BlocBuilder<ExerciseEquipmentCubit,
                  ExerciseEquipmentState>(
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
                    final List<EquipmentsEntity> equipmentList = exercises
                        .map((e) => e.equipment)
                        .where((e) => e != null)
                        .map((e) => (e as EquipmentsModel).toEntity())
                        .toSet()
                        .toList();

                    return Stack(
                      children: [
                        ExerciseSubCategoryDetails(
                          subCategoryId: subCategoryId,
                          subCategoryName: subCategoryName,
                          exercises: exercises,
                          description: description,
                          level: level,
                          totalDuration: totalDuration,
                          kcal: kcal,
                          image: image,
                          totalExercise: exercises.length,
                          equipments: equipmentList,
                        ),
                        ExerciseButton(
                          exercises: exercises,
                          kcal: kcal,
                          duration: totalDuration,
                          markAsDayCompleted: markAsDayCompleted,
                          day: day,
                          subCategoryId: subCategoryId,
                        )
                      ],
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

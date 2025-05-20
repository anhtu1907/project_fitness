import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_by_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_by_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_button.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_sub_category_details.dart';

class ExerciseBySubCategoryView extends StatelessWidget {
  final int subCategoryId;
  const ExerciseBySubCategoryView({super.key, required this.subCategoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ExerciseBySubCategoryCubit()
          ..listExerciseBySubCategoryId(subCategoryId),
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
              final subCategoryName =
                  state.entity.first.subCategory!.subCategoryName;
              final description = state.entity.first.subCategory!.description;
              final level = state.entity.first.subCategory!.mode!.modeName;
              final totalDuration = state.entity
                  .fold<int>(0, (sum, item) => sum += item.duration);
              final kcal =
                  state.entity.fold<double>(0, (sum, item) => sum += item.kcal);

              return Stack(
                children: [
                  ExerciseSubCategoryDetails(
                    subCategoryId: subCategoryId,
                    subCategoryName: subCategoryName,
                    exercises: state.entity,
                    description: description,
                    level: level,
                    totalDuration: totalDuration,
                    kcal: kcal,
                    totalExercise: state.entity.length,
                  ),
                  ExerciseButton(
                    exercises: state.entity,
                    subCategoryId: state.entity.first.subCategory!.id,
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

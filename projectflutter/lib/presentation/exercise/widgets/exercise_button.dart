import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/dialog/show_dialog.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/button_exercise_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_start.dart';

class ExerciseButton extends StatelessWidget {
  final List<ExercisesEntity> exercises;
  final int subCategoryId;
  const ExerciseButton(
      {super.key, required this.exercises, required this.subCategoryId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            ButtonExerciseCubit()..checkExerciseState(subCategoryId),
        child: BlocBuilder<ButtonExerciseCubit, ButtonExerciseState>(
          builder: (context, state) {
            if (state is ButtonInitialize) {
              return startButton(context, exercises);
            } else if (state is ButtonRestart) {
              return resetButton(context, exercises);
            } else if (state is ButtonContinue) {
              return continueButton(context, exercises);
            }
            return Container();
          },
        ));
  }

  Widget startButton(BuildContext context, List<ExercisesEntity> exercises) {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              AppNavigator.push(
                context,
                ExerciseStart(exercises: exercises, currentIndex: 0),
              );
            },
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: const Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget resetButton(BuildContext context, List<ExercisesEntity> exercises) {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              await context
                  .read<ButtonExerciseCubit>()
                  .incrementResetBatch(subCategoryId);
              final resetBatch =
                  await context.read<ButtonExerciseCubit>().getResetBatch();
              if (context.mounted) {
                AppNavigator.push(
                  context,
                  ExerciseStart(
                    exercises: exercises,
                    currentIndex: 0,
                    resetBatch: resetBatch,
                  ),
                );
              }
            },
            icon: Icon(Icons.replay, color: AppColors.whiteWorkout),
            label: Text(
              'Restart',
              style: TextStyle(
                color: AppColors.whiteWorkout,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.obesitysecond,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget continueButton(BuildContext context, List<ExercisesEntity> exercises) {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              var shouldContinue = await ShowDialog.shouldContinue(
                  context, 'Continue?', 'Are you sure want to continue?');
              if (shouldContinue == true) {
                var currentIndex = await context
                    .read<ButtonExerciseCubit>()
                    .getNextExerciseIndex(exercises);
                final resetBatch = await context
                    .read<ButtonExerciseCubit>()
                    .getResetBatchBySubCategory(subCategoryId);
                if (context.mounted && currentIndex != null) {
                  AppNavigator.push(
                    context,
                    ExerciseStart(
                      exercises: exercises,
                      currentIndex: currentIndex,
                      resetBatch: resetBatch!,
                    ),
                  );
                }
              }
            },
            icon: Icon(Icons.arrow_forward, color: AppColors.whiteWorkout),
            label: Text(
              'Continue',
              style: TextStyle(
                color: AppColors.whiteWorkout,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryWorkout,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Continue?'),
          content: const Text('Are you sure you want to continue?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Trả về true/false tùy theo lựa chọn
  }
}

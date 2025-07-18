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
  final double kcal;
  final int subCategoryId;
  final bool markAsDayCompleted;
  final int? day;
  final int? duration;
  const ExerciseButton(
      {super.key,
      required this.exercises,
      required this.kcal,
        required this.duration,
        this.day,
        this.markAsDayCompleted = false,
      required this.subCategoryId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ButtonExerciseCubit(),
        child: BlocBuilder<ButtonExerciseCubit, ButtonExerciseState>(
          builder: (context, state) {
            return _startButton(context, exercises);
          },
        ));
  }

  Widget _startButton(BuildContext context, List<ExercisesEntity> exercises) {
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

              if (context.mounted) {
                AppNavigator.push(
                  context,
                  ExerciseStart(
                    exercises: exercises,
                    kcal: kcal,
                    markAsDayCompleted: markAsDayCompleted,
                    day: day,
                    subCategoryId: subCategoryId,
                  ),
                );
              }
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
}

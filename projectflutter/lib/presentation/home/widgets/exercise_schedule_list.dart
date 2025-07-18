import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/presentation/home/widgets/exercise_schedule_row.dart';

class ExerciseScheduleList extends StatelessWidget {
  const ExerciseScheduleList({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          ExerciseScheduleCubit()..loadScheduleandNotification(),
        ),
        BlocProvider(
          create: (context) => ExercisesCubit()..listExercise(),
        ),
      ],
      child: BlocBuilder<ExerciseScheduleCubit, ExerciseScheduleState>(
        builder: (context, scheduleState) {
          if (scheduleState is ExerciseScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (scheduleState is LoadExerciseScheduleFailure) {
            return Center(child: Text(scheduleState.errorMessage));
          }

          if (scheduleState is ExerciseScheduleLoaded) {
            final listSchedule = scheduleState.entity;

            if (listSchedule.isEmpty) {
              return const SizedBox(
                height: 60,
                child: Center(child: Text('No recent schedule available')),
              );
            }

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

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    shrinkWrap: true,
                    itemCount:
                    listSchedule.length > 2 ? 2 : listSchedule.length,
                    itemBuilder: (context, index) {
                      final schedule = listSchedule[index];
                      final subCategoryId = schedule.subCategory?.id;
                      final relatedExercises = listExercise
                          .where((ex) =>
                          ex.subCategory.any(
                                  (sub) => sub.id == subCategoryId))
                          .toList();
                      final String levelName = relatedExercises.isNotEmpty
                          ? relatedExercises.first.modes.first.modeName
                          : 'No level info';

                      return ExerciseScheduleRow(
                        entity: schedule,
                        level: levelName,
                      );
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

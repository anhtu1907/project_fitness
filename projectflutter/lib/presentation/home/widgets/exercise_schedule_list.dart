import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
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
        builder: (context, state) {
          if (state is ExerciseScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadExerciseScheduleFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is ExerciseScheduleLoaded) {
            final listSchedule = state.entity;
            if (listSchedule.isEmpty) {
              return const SizedBox(
                  height: 60,
                  child: Center(
                    child: Text('No recent schedule available'),
                  ));
            }
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
                  final listExercise = state.entity;
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 8),
                    shrinkWrap: true,
                    itemCount:
                        listSchedule.length > 2 ? 2 : listSchedule.length,
                    itemBuilder: (context, index) {
                      final schedule = listSchedule[index];

                      final subCategoryId = schedule.subCategory?.id;
                      ExercisesEntity? exerciseForSchedule;
                      String? levelName;
                      try {
                        exerciseForSchedule = listExercise.firstWhere(
                              (ex) => ex.subCategory.any((sub) => sub.id == subCategoryId),
                        );
                      } catch (e) {
                        exerciseForSchedule = null;
                      }

                      if (exerciseForSchedule != null) {
                        levelName = exerciseForSchedule.mode?.modeName;
                      }

                      return ExerciseScheduleRow(
                        entity: listSchedule[index],
                        level: levelName!,
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

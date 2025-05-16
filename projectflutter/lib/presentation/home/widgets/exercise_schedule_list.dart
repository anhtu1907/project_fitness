import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/presentation/home/widgets/exercise_schedule_row.dart';

class ExerciseScheduleList extends StatelessWidget {
  const ExerciseScheduleList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseScheduleCubit()..displaySchedule(),
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
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              shrinkWrap: true,
              itemCount: listSchedule.length > 2 ? 2 : listSchedule.length,
              itemBuilder: (context, index) {
                return ExerciseScheduleRow(entity: listSchedule[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

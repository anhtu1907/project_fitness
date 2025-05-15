import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/presentation/home/widgets/exercise_schedule_row.dart';

class ExerciseSchedulePage extends StatelessWidget {
  const ExerciseSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        titlte: Text(
          "Exercise Schedules",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocProvider(
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
                itemCount: listSchedule.length,
                itemBuilder: (context, index) {
                  return ExerciseScheduleRow(entity: listSchedule[index]);
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

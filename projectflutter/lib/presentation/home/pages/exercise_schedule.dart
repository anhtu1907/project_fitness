import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/presentation/home/widgets/exercise_schedule_row.dart';

class ExerciseSchedulePage extends StatelessWidget {
  const ExerciseSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        title: Text(
          "All Schedule",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            ExerciseScheduleCubit()..loadScheduleandNotification(),
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
                padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
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

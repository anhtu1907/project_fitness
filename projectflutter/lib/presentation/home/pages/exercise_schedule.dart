import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_state.dart';
import 'package:projectflutter/presentation/home/pages/tabs.dart';
import 'package:projectflutter/presentation/home/widgets/exercise_schedule_row.dart';

class ExerciseSchedulePage extends StatelessWidget {
  const ExerciseSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          "All Schedule",
          style: TextStyle(
              fontSize: AppFontSize.titleAppBar(context),
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          AppNavigator.pushAndRemoveUntil(context, const TabsPage());
        },
      ),
      body: MultiBlocProvider(
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
                      padding: const EdgeInsets.only(bottom: 8,left: 10, right: 10),
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
                            (ex) => ex.subCategory
                                .any((sub) => sub.id == subCategoryId),
                          );
                        } catch (e) {
                          exerciseForSchedule = null;
                        }

                        if (exerciseForSchedule != null) {
                          levelName = exerciseForSchedule.modes.first.modeName;
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
      ),
    );
  }
}

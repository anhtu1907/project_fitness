import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/profile/bloc/history_cubit.dart';
import 'package:projectflutter/presentation/profile/bloc/history_state.dart';
import 'package:projectflutter/presentation/profile/widgets/calendar_custom.dart';
import 'package:projectflutter/presentation/profile/widgets/workout_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BasicAppBar(
          hideBack: false,
          title: Text(
            "Activity History",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocProvider(
            create: (context) => HistoryCubit()..displayHistory(),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                      height: 150,
                      child: Builder(builder: (context) {
                        return CalendarCustom(
                          onDateSelected: (selectedDate) => context
                              .read<HistoryCubit>()
                              .filterExerciseResultByDate(selectedDate),
                        );
                      })),
                  BlocBuilder<HistoryCubit, HistoryState>(
                      builder: (context, state) {
                    if (state is HistoryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is LoadHistoryFailure) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    }
                    if (state is HistoryLoaded) {
                      if (state.listHistory.isEmpty) {
                        return const Center(
                          child: Text('No exercise history for selected date'),
                        );
                      } else {
                        Map<String, List<ExerciseUserEntity>>
                            groupedCategoryResetBatch = {};
                        for (var history in state.listHistory) {
                          final subCategoryName =
                              history.session!.exercise!.subCategory!.subCategoryName;
                          final resetBatch = history.session!.resetBatch;
                          final key = '$subCategoryName-$resetBatch';
                          if (groupedCategoryResetBatch.containsKey(key)) {
                            groupedCategoryResetBatch[key]!.add(history);
                          } else {
                            groupedCategoryResetBatch[key] = [history];
                          }
                        }

                        final sortedEntries = groupedCategoryResetBatch.entries
                            .toList()
                          ..sort((a, b) {
                            final aUpdated = getLatestUpdated(a.value);
                            final bUpdated = getLatestUpdated(b.value);

                            if (aUpdated == null && bUpdated == null) return 0;
                            if (aUpdated == null) return 1;
                            if (bUpdated == null) return -1;
                            return bUpdated.compareTo(aUpdated);
                          });

                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: sortedEntries.map((entry) {
                                final list = entry.value;
                                var time = list.first.createdAt;
                                var formatedTime =
                                    DateFormat('HH:mm').format(time!);
                                var subCategoryId =
                                    list.first.session!.exercise!.subCategory!.id;
                                var subCategoryName = list.first.session!.exercise!
                                    .subCategory!.subCategoryName;
                                var subCategoryImage = list.first.session!
                                    .exercise!.subCategory!.subCategoryImage;
                                var duration = list.fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum + (item.session?.duration ?? 0));
                                var totalKcal = list.fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item.session?.kcal ?? 0));
                                return WorkoutHistory(
                                  image: (subCategoryImage == '' ||
                                          subCategoryImage.isEmpty)
                                      ? exerciseSubCategory[subCategoryId].toString()
                                      : subCategoryImage,
                                  name: subCategoryName,
                                  duration: duration,
                                  totalExercise: list.length,
                                  kcal: totalKcal,
                                  time: formatedTime,
                                );
                              }).toList(),
                            ));
                      }
                    }
                    return Container();
                  })
                ],
              )),
            )));
  }
}

DateTime? getLatestUpdated(List<ExerciseUserEntity> list) {
  return list
      .map((e) => e.createdAt)
      .whereType<DateTime>()
      .fold<DateTime?>(null, (prev, curr) {
    if (prev == null || curr.isAfter(prev)) return curr;
    return prev;
  });
}

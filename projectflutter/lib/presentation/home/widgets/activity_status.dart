import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';
import 'package:projectflutter/presentation/run/bloc/run_record_cubit.dart';
import 'package:projectflutter/presentation/run/bloc/run_record_state.dart';

class ActivityStatus extends StatefulWidget {
  const ActivityStatus({super.key});

  @override
  State<ActivityStatus> createState() => _ActivityStatusState();
}

class _ActivityStatusState extends State<ActivityStatus> {
  String selectedTime = 'Daily';
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExerciseUserCubit()..listExerciseUser(),
        ),
        BlocProvider(
          create: (context) => RunRecordCubit()..listRunByUserId(),
        )
      ],
      child: BlocBuilder<ExerciseUserCubit, ExerciseUserState>(
        builder: (context, state) {
          if (state is ExerciseUserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadExerciseUserFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is ExerciseUserLoaded) {
            final listExerciseByUserId = state.entity;
            return BlocBuilder<RunRecordCubit, RunRecordState>(
              builder: (context, state) {
                if (state is RunRecordLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is LoadRunRecordFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                if (state is RunRecordLoaded) {
                  final listRunByUserId = state.listRun;
                  Map<String, double> kcalByTimeOfDay = {
                    'Morning': 0,
                    'Afternoon': 0,
                    'Evening': 0,
                  };

                  final Map<String, Color> timeColors = {
                    'Morning': AppColors.morning,
                    'Afternoon': AppColors.afternoon,
                    'Evening': AppColors.evening,
                  };

                  // Filter theo Record của Run và Exercise
                  final now = DateTime.now();
                  List<dynamic> mergeList = [
                    ...listExerciseByUserId,
                    ...listRunByUserId
                  ];
                  List<dynamic> filteredEntities = [];
                  if (selectedTime == "Daily") {
                    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
                    filteredEntities = mergeList.where((entity) {
                      if (entity.createdAt == null) return false;
                      final createdDate =
                          DateFormat('dd/MM/yyyy').format(entity.createdAt!);
                      return createdDate == formattedDate;
                    }).toList();
                  } else if (selectedTime == 'Weekly') {
                    final startOfWeek =
                        now.subtract(Duration(days: now.weekday - 1));
                    final endOfWeek = startOfWeek.add(const Duration(days: 6));
                    filteredEntities = mergeList.where((entity) {
                      if (entity.createdAt == null) return false;
                      return entity.createdAt!.isAfter(
                              startOfWeek.subtract(const Duration(days: 1))) &&
                          entity.createdAt!
                              .isBefore(endOfWeek.add(const Duration(days: 1)));
                    }).toList();
                  } else if (selectedTime == 'Monthly') {
                    filteredEntities = mergeList.where((entity) {
                      if (entity.createdAt == null) return false;
                      return entity.createdAt!.month == now.month &&
                          entity.createdAt!.year == now.year;
                    }).toList();
                  } else if (selectedTime == 'Year') {
                    filteredEntities = mergeList.where((entity) {
                      if (entity.createdAt == null) return false;
                      return entity.createdAt!.year == now.year;
                    }).toList();
                  }

                  var totalKcal = filteredEntities.fold<double>(
                      0, (sum, item) => sum += item.kcal);
                  for (var entity in filteredEntities) {
                    if (entity.createdAt == null) continue;
                    final hour = entity.createdAt!.hour;

                    if (hour >= 5 && hour < 12) {
                      kcalByTimeOfDay['Morning'] =
                          kcalByTimeOfDay['Morning']! + entity.kcal;
                    } else if (hour >= 12 && hour < 18) {
                      kcalByTimeOfDay['Afternoon'] =
                          kcalByTimeOfDay['Afternoon']! + entity.kcal;
                    } else {
                      kcalByTimeOfDay['Evening'] =
                          kcalByTimeOfDay['Evening']! + entity.kcal;
                    }
                  }
                  List<PieChartSectionData> sections = totalKcal == 0
                      ? [
                          PieChartSectionData(
                            value: 1,
                            color: Colors.grey.shade300,
                            title: '0 kcal',
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        ]
                      : kcalByTimeOfDay.entries.map((entry) {
                          final timeOfDay = entry.key;
                          final kcal = entry.value;
                          double percentage = kcal / totalKcal * 100;
                          return PieChartSectionData(
                            value: percentage,
                            color: timeColors[timeOfDay],
                            title: '${entry.value.toStringAsFixed(0)} kcal',
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            titlePositionPercentageOffset: 0.6,
                          );
                        }).toList();
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double chartHeight = constraints.maxWidth * 0.6;
                      return Container(
                        height: chartHeight + 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor2.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Calories Burned',
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${totalKcal.toStringAsFixed(0)} kcal',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.primaryColor1,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Image.asset(
                                              AppImages.fire,
                                              width: 25,
                                              height: 25,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        setState(() {
                                          selectedTime = value;
                                        });
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Year',
                                          child: Text('Year'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Monthly',
                                          child: Text('Monthly'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Weekly',
                                          child: Text('Weekly'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Daily',
                                          child: Text('Daily'),
                                        ),
                                      ],
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor1,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              selectedTime,
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 16,
                                              color: AppColors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: sections,
                                  centerSpaceRadius: 0,
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children:
                                      kcalByTimeOfDay.entries.map((entry) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          color: timeColors[entry.key],
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ))
                          ],
                        ),
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

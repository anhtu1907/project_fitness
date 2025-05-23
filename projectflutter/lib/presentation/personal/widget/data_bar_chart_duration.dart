import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';

class DataBarChartDuration extends StatefulWidget {
  const DataBarChartDuration({super.key});

  @override
  State<DataBarChartDuration> createState() => _DataBarChartDurationState();
}

class _DataBarChartDurationState extends State<DataBarChartDuration> {
  final todayIndex = DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExerciseUserCubit()..resultUser(),
      child: BlocBuilder<ExerciseUserCubit, ExerciseUserState>(
        builder: (context, state) {
          if (state is LoadExerciseUserFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is ExerciseUserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ExerciseUserLoaded) {
            final listResult = state.entity;
            final durationSeconds = listResult.fold(0, (sum,item) => sum += item.session!.duration);
            int durationInMinutes = (durationSeconds / 60).floor();
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              durationInMinutes.toString(),
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'min',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 85,
                      width: MediaQuery.of(context).size.width,
                      child: BarChart(BarChartData(
                          barGroups: _getBarGroups(listResult),
                          titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 35,
                                      getTitlesWidget: _getBottomTitles))),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false))),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<ExerciseUserEntity> listResult) {
    final now = DateTime.now();
    final beginingOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = beginingOfWeek.add(const Duration(days: 6));
    final filteredList = listResult.where((reuslt) {
      final createdAt = reuslt.createdAt;
      if (createdAt == null) return false;
      return createdAt
          .isAfter(beginingOfWeek.subtract(const Duration(seconds: 1))) && // 00:00:00
          createdAt.isBefore(endOfWeek.add(const Duration(days: 1))); // 23:59:59
    }).toList();

    Map<int, double> minDay = {for (int i = 1; i <= 7; i++) i: 0};

    for (var item in filteredList) {
      if (item.createdAt != null) {
        int weekDay = item.createdAt!.weekday;
        minDay[weekDay] = minDay[weekDay]! + item.session!.duration;
      }
    }
    final maxTime = minDay.values.reduce((a, b) => a > b ? a : b); // Return max
    final maxY = maxTime == 0 ? 1.0 : maxTime;

    return List.generate(7, (index) {
      double time = minDay[index + 1] ?? 0;
      double toY = time == 0 ? 0.1 : time;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          toY: toY,
          color: AppColors.durationChart,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Colors.grey.shade200,
          ),
        )
      ]);
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const defaultStyle = TextStyle(color: Colors.black, fontSize: 12);
    final highlightStyle = TextStyle(
        color: AppColors.durationBottomTitle,
        fontSize: 12,
        fontWeight: FontWeight.bold);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final label = labels[value.toInt()];
    final isToday = value.toInt() == todayIndex;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: isToday ? highlightStyle : defaultStyle,
        ),
        if (isToday)
          Icon(Icons.arrow_drop_up, color: AppColors.durationBottomTitle, size: 18),
      ],
    );
  }
}

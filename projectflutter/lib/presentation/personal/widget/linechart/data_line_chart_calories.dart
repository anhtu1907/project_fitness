import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';

class DataLineChartCalories extends StatefulWidget {
  const DataLineChartCalories({super.key});

  @override
  State<DataLineChartCalories> createState() => _DataLineChartCaloriesState();
}

class _DataLineChartCaloriesState extends State<DataLineChartCalories> {
  int selectedMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExerciseUserCubit()..resultUser(),
          ),
        ],
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
              final now = DateTime.now();
              final beginningOfMonth = DateTime(now.year, selectedMonth, 1);
              final endOfMonth = DateTime(now.year, selectedMonth + 1, 1)
                  .subtract(Duration(days: 1));
              final filteredList = listResult.where((item) {
                final createdAt = item.createdAt;
                if (createdAt == null) return false;
                return createdAt.isAfter(beginningOfMonth
                        .subtract(const Duration(seconds: 1))) &&
                    createdAt.isBefore(endOfMonth.add(const Duration(days: 1)));
              }).toList();
              final dayToKcal = <int, double>{};
              for (var item in filteredList) {
                final createdAt = item.createdAt!;
                final day = createdAt.day;
                dayToKcal[day] = (dayToKcal[day] ?? 0) + item.kcal;
              }

              final maxY = dayToKcal.values.isNotEmpty
                  ? dayToKcal.values.reduce((a, b) => a > b ? a : b)
                  : 20.0;
              final daysInMonth = endOfMonth.day;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.gray.withOpacity(0.15),
                    ),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Burned Calories ',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSize.content(context)),
                            ),
                            Text(
                              '(kcal)',
                              style: TextStyle(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      AppFontSize.valueLineChart(context)),
                            ),
                          ],
                        ),
                        Container(
                          width: media.width * 0.2,
                          decoration: BoxDecoration(
                              color: AppColors.caloriesChart,
                              borderRadius: BorderRadius.circular(20)),
                          child: DropdownButton<int>(
                            items: List.generate(
                              12,
                              (index) => index + 1,
                            ).map((month) {
                              final monthName =
                                  DateFormat('MMM').format(DateTime(0, month));
                              return DropdownMenuItem(
                                  value: month, child: Text(monthName));
                            }).toList(),
                            value: selectedMonth,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedMonth = value;
                                });
                              }
                            },
                            underline: const SizedBox(),
                            style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.body(context)),
                            dropdownColor: AppColors.caloriesChart,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            iconEnabledColor: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    _lineChart(context,maxY, daysInMonth, dayToKcal),
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }
}

Widget _lineChart(BuildContext context,double maxY, int daysInMonth, Map<int, double> dayToKcal) {
  double chartWidth = daysInMonth * 40;
  return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              maxY: maxY + (maxY / 5),
              minY: 0,
              barGroups: List.generate(daysInMonth, (index) {
                final day = index + 1;
                final toY = dayToKcal[day] ?? 0;
                return BarChartGroupData(x: day, barRods: [
                  BarChartRodData(
                      toY: toY,
                      color: AppColors.caloriesChart,
                      width: 16,
                      borderRadius: BorderRadius.circular(4))
                ]);
              }),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 5 ? (maxY / 5).ceilToDouble() : 1,
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Colors.grey, width: 1),
                  bottom: BorderSide(color: Colors.grey, width: 1),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: maxY > 0 ? (maxY / 5).ceilToDouble() : 2,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('${value.toInt()}',
                            style: TextStyle(fontSize: AppFontSize.valueLineChart(context)),
                      ));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 1,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('${value.toInt()}',
                            style: TextStyle(fontSize: AppFontSize.valueLineChart(context))),
                      );
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ),
      ));
}

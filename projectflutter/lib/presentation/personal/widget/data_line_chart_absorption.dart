import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_state.dart';

class DataLineChartAbsorption extends StatefulWidget {
  const DataLineChartAbsorption({super.key});

  @override
  State<DataLineChartAbsorption> createState() =>
      _DataLineChartAbsorptionState();
}

class _DataLineChartAbsorptionState extends State<DataLineChartAbsorption> {
  int selectedMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserMealCubit()..listRecord(),
          ),
        ],
        child: BlocBuilder<UserMealCubit, UserMealState>(
          builder: (context, state) {
            if (state is UserMealLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LoadUserMealFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            if (state is UserMealLoaded) {
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
                dayToKcal[day] =
                    (dayToKcal[day] ?? 0) + item.meal.kcal;
              }

              final maxY = dayToKcal.values.isNotEmpty ? dayToKcal.values.reduce((a,b) => a > b ? a :b) : 20.0;
              final daysInMonth = endOfMonth.day;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Absorb ',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            Text(
                              '(kcal)',
                              style: TextStyle(
                                  color: AppColors.gray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width *0.2,
                          decoration: BoxDecoration(
                              color: AppColors.absorptionChart,
                              borderRadius: BorderRadius.circular(20)
                          ),
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
                            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            dropdownColor: AppColors.absorptionChart,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            iconEnabledColor: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    _lineChart(maxY, daysInMonth,dayToKcal),
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }
}

Widget _lineChart(double maxY, int daysInMonth,Map<int,double> dayToKcal) {
  double chartWidth = daysInMonth * 40;
  return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              maxY: maxY + (maxY/5),
              minY: 0,
              barGroups: List.generate(daysInMonth, (index) {
                final day = index + 1;
                final toY = dayToKcal[day] ?? 0;
                return BarChartGroupData(x: day, barRods: [
                  BarChartRodData(
                      toY: toY,
                      color: AppColors.absorptionChart,
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
                            style: const TextStyle(fontSize: 10)),
                      );
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
                            style: const TextStyle(fontSize: 10)),
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

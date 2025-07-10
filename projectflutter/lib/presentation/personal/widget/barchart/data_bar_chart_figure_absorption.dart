import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_state.dart';

class DataBarChartFigureAbsorption extends StatefulWidget {
  const DataBarChartFigureAbsorption({super.key});

  @override
  State<DataBarChartFigureAbsorption> createState() =>
      _DataBarChartFigureAbsorptionState();
}

class _DataBarChartFigureAbsorptionState
    extends State<DataBarChartFigureAbsorption> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => UserMealCubit()..listRecord(),
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

            final year = now.year;
            final groupedOfWeek = groupByWeek(listResult);
            final sortedEntries = groupedOfWeek.entries.toList()
              ..sort((a, b) {
                final dateA = DateFormat('MMM d').parse(a.key.split(' - ')[0]);
                final dateB = DateFormat('MMM d').parse(b.key.split(' - ')[0]);
                return dateB.compareTo(dateA);
              });
            final Set<String> displayedMonths = {};
            return SingleChildScrollView(
                child:
                Column(
                    children: sortedEntries.map((entry) {
                  final weekday = entry.key;
                  final weekList = entry.value;
                  final totalAbsorb =
                      weekList.fold(0.0, (sum, item) => sum + item.meal.kcal);
                  final averageAbsorb = totalAbsorb / 7;
                  final firstDate = weekList.first.createdAt;
                  String monthName = DateFormat('MMM').format(firstDate!);
                  final formattedDate = '$monthName $year';
                  final shouldDisplayMonth = !displayedMonths.contains(monthName);
                  if(shouldDisplayMonth){
                    displayedMonths.add(monthName);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (shouldDisplayMonth)
                        Text(
                          formattedDate,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: AppFontSize.body(context),
                              fontWeight: FontWeight.bold),
                        ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.gray.withOpacity(0.15),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          weekday,
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: media.height * 0.01,
                                        ),
                                        Text(
                                          '$year',
                                          style: TextStyle(color: AppColors.gray),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          averageAbsorb.toStringAsFixed(0),
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: media.height * 0.01,
                                        ),
                                        Text(
                                          'Average (kcal)',
                                          style: TextStyle(color: AppColors.gray),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: media.height * 0.02,
                            ),
                            SizedBox(
                              height: media.height * 0.12,
                              width: media.width,
                              child: BarChart(BarChartData(
                                  barGroups: _getBarGroups(weekList),
                                  titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 35,
                                              getTitlesWidget: _getBottomTitles))),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(show: false))),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSize.value13Text(context)),
                                    ),
                                    Text(
                                      '${totalAbsorb.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSize.value13Text(context)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: media.height * 0.02,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: media.width * 0.04,
                                          height:  media.width * 0.04,
                                          decoration: BoxDecoration(
                                              color: AppColors.absorptionChart,
                                              shape: BoxShape.circle),
                                        ),
                                        SizedBox(width: media.width * 0.02,),
                                        Text(
                                          'Meal',
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFontSize.value13Text(context)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${totalAbsorb.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppFontSize.value13Text(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList()),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<UserMealsEntity> filteredList) {
    Map<int, double> caloriesDay = {for (int i = 1; i <= 7; i++) i: 0};

    for (var item in filteredList) {
      if (item.createdAt != null) {
        int weekDay = item.createdAt!.weekday;
        caloriesDay[weekDay] = caloriesDay[weekDay]! + item.meal.kcal;
      }
    }
    final maxKcal =
        caloriesDay.values.reduce((a, b) => a > b ? a : b); // Return max
    final maxY = maxKcal == 0 ? 1.0 : maxKcal;

    return List.generate(7, (index) {
      double kcal = caloriesDay[index + 1] ?? 0;
      double toY = kcal == 0 ? 0.1 : kcal;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: toY,
            color: kcal > 0
                ? AppColors.absorptionChart
                : AppColors.gray.withOpacity(0.5),
            width: 12,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                color: Colors.grey.shade200, toY: maxY, show: true))
      ]);
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    var defaultStyle = TextStyle(
        color: Colors.black, fontSize: AppFontSize.caption(context), fontWeight: FontWeight.bold);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final label = labels[value.toInt()];
    return Text(
      label,
      style: defaultStyle,
    );
  }

  Map<String, List<UserMealsEntity>> groupByWeek(List<UserMealsEntity> list) {
    Map<String, List<UserMealsEntity>> grouped = {};
    for (var item in list) {
      if (item.createdAt != null) {
        final date = item.createdAt!;
        final beginningOfWeek = DateTime(date.year, date.month, date.day)
            .subtract(Duration(days: date.weekday - 1));
        final endOfWeek = beginningOfWeek.add(const Duration(days: 6));
        final formattedStart = DateFormat('MMM d').format(beginningOfWeek);
        final formattedEnd = DateFormat('MMM d').format(endOfWeek);

        final key = '$formattedStart - $formattedEnd';
        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        grouped[key]!.add(item);
      }
    }
    return grouped;
  }
}

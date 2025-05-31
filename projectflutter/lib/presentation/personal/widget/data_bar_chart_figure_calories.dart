import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';

class DataBarChartFigureCalories extends StatefulWidget {
  const DataBarChartFigureCalories({super.key});

  @override
  State<DataBarChartFigureCalories> createState() =>
      _DataBarChartFigureCaloriesState();
}

class _DataBarChartFigureCaloriesState
    extends State<DataBarChartFigureCalories> {
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
            final now = DateTime.now();

            final year = now.year;
            final groupedOfWeek = groupByWeek(listResult);
            final sortedEntries = groupedOfWeek.entries.toList()
              ..sort((a, b) {
                final dateA = DateFormat('MMM d').parse(a.key.split(' - ')[0]);
                final dateB = DateFormat('MMM d').parse(b.key.split(' - ')[0]);
                return dateB.compareTo(dateA);
              });
            return SingleChildScrollView(
                child: Column(
                    children: sortedEntries.map((entry){
                      final weekday = entry.key;
                      final weekList = entry.value;
                      final totalKcal = weekList.fold(0.0, (sum, item) => sum + item.session!.kcal);
                      final averageCalories = totalKcal/ 7;
                      return  Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                                        const SizedBox(
                                          height: 5,
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
                                          averageCalories.toStringAsFixed(0),
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
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
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 85,
                              width: MediaQuery.of(context).size.width,
                              child: BarChart(BarChartData(
                                  barGroups: _getBarGroups(weekList),
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
                                          fontSize: 13),
                                    ),
                                    Text(
                                      '${totalKcal.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: AppColors.caloriesChart,
                                              shape: BoxShape.circle
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Text(
                                          'Workout',
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${totalKcal.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],

                        ),
                      );

                    }).toList()

                )
            );
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<ExerciseUserEntity> filteredList) {
    Map<int, double> caloriesDay = {for (int i = 1; i <= 7; i++) i: 0};

    for (var item in filteredList) {
      if (item.createdAt != null) {
        int weekDay = item.createdAt!.weekday;
        caloriesDay[weekDay] = caloriesDay[weekDay]! + item.kcal;
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
            color: kcal > 0 ? AppColors.caloriesChart : AppColors.gray.withOpacity(0.5),
            width: 12,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                color: Colors.grey.shade200, toY: maxY, show: true))
      ]);
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const defaultStyle = TextStyle(
        color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final label = labels[value.toInt()];
    return Text(
      label,
      style: defaultStyle,
    );
  }

  Map<String,List<ExerciseUserEntity>> groupByWeek(List<ExerciseUserEntity> list){
    Map<String,List<ExerciseUserEntity>> grouped = {};
    for(var item in list){
      if(item.createdAt != null){
        final date = item.createdAt!;
        final beginningOfWeek = DateTime(date.year, date.month, date.day)
            .subtract(Duration(days: date.weekday - 1));
        final endOfWeek = beginningOfWeek.add(const Duration(days: 6));
        final formattedStart = DateFormat('MMM d').format(beginningOfWeek);
        final formattedEnd = DateFormat('MMM d').format(endOfWeek);

        final key = '$formattedStart - $formattedEnd';
        if(!grouped.containsKey(key)){
          grouped[key] = [];
        }
        grouped[key]!.add(item);
      }
    }
    return grouped;
  }
}

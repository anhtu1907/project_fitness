import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';

class DataBarChartFigureDuration extends StatefulWidget {
  const DataBarChartFigureDuration({super.key});

  @override
  State<DataBarChartFigureDuration> createState() =>
      _DataBarChartFigureDurationState();
}

class _DataBarChartFigureDurationState
    extends State<DataBarChartFigureDuration> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
            final Set<String> displayedMonths = {};
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                        children: sortedEntries.map((entry){
                          final weekday = entry.key;
                          final weekList = entry.value;
                          final totalDuration = weekList.fold(0.0, (sum, item) => sum + item.session!.duration);
                          final totalMinutes = (totalDuration / 60).floor();
                          final averageMinutes = totalMinutes/ 7;
                          final firstDate = weekList.first.createdAt;
                          String monthName = DateFormat('MMM').format(firstDate!);
                          final formattedDate = '$monthName ${firstDate.year}';
                          final shouldDisplayMonth = !displayedMonths.contains(monthName);
                          if(shouldDisplayMonth){
                            displayedMonths.add(monthName);
                          }
                          return  Column(
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
                                                  averageMinutes.toStringAsFixed(0),
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: media.height * 0.01,
                                                ),
                                                Text(
                                                  'Average (mins)',
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
                                    SizedBox(height: media.height * 0.02,),
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
                                              '${totalMinutes.toStringAsFixed(0)} mins',
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
                                                      color: AppColors.durationChart,
                                                      shape: BoxShape.circle
                                                  ),
                                                ),
                                                SizedBox(width: media.width * 0.02,),
                                                Text(
                                                  'Workout',
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: AppFontSize.value13Text(context)),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${totalMinutes.toStringAsFixed(0)} mins',
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

                        }).toList()

                    ),
                  ],
                )
            );
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<ExerciseUserEntity> filteredList) {
    Map<int, double> minsDay = {for (int i = 1; i <= 7; i++) i: 0};

    for (var item in filteredList) {
      if (item.createdAt != null) {
        int weekDay = item.createdAt!.weekday;
        minsDay[weekDay] = minsDay[weekDay]! + (item.session!.duration / 60);
      }
    }
    final maxDuration =
    minsDay.values.reduce((a, b) => a > b ? a : b); // Return max
    final maxY = maxDuration == 0 ? 1.0 : maxDuration;

    return List.generate(7, (index) {
      double minute = minsDay[index + 1] ?? 0;
      double toY = minute == 0 ? 0.1 : minute;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: toY,
            color:minute > 0 ?  AppColors.durationChart : AppColors.gray.withOpacity(0.5),
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

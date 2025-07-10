import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';
import 'package:projectflutter/presentation/personal/pages/figure_duration_view.dart';

class DataBarChartDuration extends StatefulWidget {
  const DataBarChartDuration({super.key});

  @override
  State<DataBarChartDuration> createState() => _DataBarChartDurationState();
}

class _DataBarChartDurationState extends State<DataBarChartDuration> {
  final todayIndex = DateTime.now().weekday - 1;
  bool _isPressed = false;
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
            final beginningOfWeek = DateTime(now.year, now.month, now.day)
                .subtract(Duration(days: now.weekday - 1));
            final endOfWeek = beginningOfWeek.add(const Duration(days: 6));
            final filteredList = listResult.where((item) {
              final createdAt = item.createdAt;
              if (createdAt == null) return false;
              return createdAt.isAfter(
                  beginningOfWeek.subtract(const Duration(seconds: 1))) &&
                  createdAt.isBefore(endOfWeek.add(const Duration(days: 1)));
            }).toList();

            final durationSeconds = filteredList.fold(
                0.0, (sum, item) => sum + item.session!.duration);
            int durationInMinutes = (durationSeconds / 60).floor();
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPressed = !_isPressed;
                  });
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      _isPressed = false;
                    });
                  });
                  AppNavigator.push(context, const FigureDurationView());

                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.gray.withOpacity(0.15),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: _isPressed
                          ? [
                             const BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 6)
                            ]
                          : []),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Duration',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: AppFontSize.value20Text(context),
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: AppColors.gray,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.01,
                          ),
                          Row(
                            children: [
                              Text(
                                durationInMinutes.toString(),
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: AppFontSize.value28Text(context),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'min',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.height * 0.01,
                      ),
                      SizedBox(
                        height: media.height * 0.12,
                        width: media.width,
                        child: BarChart(BarChartData(
                            barGroups: _getBarGroups(filteredList),
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
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<ExerciseUserEntity> filteredList) {
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
    var defaultStyle = TextStyle(color: Colors.black, fontSize: AppFontSize.content(context));
    final highlightStyle = TextStyle(
        color: AppColors.durationBottomTitle,
        fontSize: AppFontSize.value13Text(context),
        fontWeight: FontWeight.bold);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final label = labels[value.toInt()];
    final isToday = value.toInt() == todayIndex;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Text(
          label,
          style: isToday ? highlightStyle : defaultStyle,
        ),
        if (isToday)
          Positioned(
            top: 13,
            child: Icon(Icons.arrow_drop_up,
                color: AppColors.durationBottomTitle, size: AppFontSize.value18Text(context)),
          )
      ],
    );
  }
}

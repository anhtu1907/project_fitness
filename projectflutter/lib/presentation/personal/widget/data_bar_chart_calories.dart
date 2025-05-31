import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';
import 'package:projectflutter/presentation/personal/pages/figure_calories_view.dart';

class DataBarChartCalories extends StatefulWidget {
  const DataBarChartCalories({super.key});

  @override
  State<DataBarChartCalories> createState() => _DataBarChartCaloriesState();
}

class _DataBarChartCaloriesState extends State<DataBarChartCalories> {
  final todayIndex = DateTime.now().weekday - 1;
  bool _isPressed = false;

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
            final calories = filteredList.fold<double>(
                0, (sum, item) => sum += item.session!.kcal);
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
                    AppNavigator.push(context, FigureCaloriesView());

                  },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isPressed ?const [BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0,4),
                      blurRadius: 6)] : []
                  
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calories',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColors.gray,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              calories.toStringAsFixed(0),
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'kcal',
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
                      height: 80,
                      width: MediaQuery.of(context).size.width,
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
                    ),
                  ],
                ),
              ),
            ));
          }
          return Container();
        },
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(List<ExerciseUserEntity> filteredList) {
    // Day of week
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
            color: AppColors.caloriesChart,
            width: 12,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
                color: Colors.grey.shade200, toY: maxY, show: true))
      ]);
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    // Style
    const defaultStyle = TextStyle(color: Colors.black, fontSize: 12);
    final highlightStyle = TextStyle(
        color: AppColors.caloriesBottomTitle,
        fontSize: 13,
        fontWeight: FontWeight.bold);
    // List labels
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
            child: Icon(
              Icons.arrow_drop_up,
              color: AppColors.caloriesBottomTitle,
              size: 18,
            ),
          ),
      ],
    );
  }
}

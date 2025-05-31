import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';
import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_state.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/personal/widget/show_dialog_current_form.dart';
import 'package:projectflutter/presentation/personal/widget/show_dialog_target_form.dart';

class DataLineChart extends StatefulWidget {
  const DataLineChart({super.key});

  @override
  State<DataLineChart> createState() => _DataLineChartState();
}

class _DataLineChartState extends State<DataLineChart> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  bool _isPressedCurrent = true;
  bool _isPressedGoal = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HealthCubit()..getDataHealth(),
        ),
        BlocProvider(
          create: (context) => HealthGoalCubit()..getHealGoal(),
        )
      ],
      child: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          if (state is LoadedHealthFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          if (state is HealthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HealthLoaded) {
            final health = state.bmi;
            final bmi = health.last.bmi;
            final maxY = health.first.weight + 5;
            final minY = health.first.weight - 15;
            double avgWeight =
                health.fold<double>(0, (sum, item) => sum += item.weight) /
                    health.length;
            double lastWeight = health.first.weight - health.last.weight;
            return BlocBuilder<HealthGoalCubit, HealthGoalState>(
              builder: (context, state) {
                if (state is LoadedHealthGoalFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                if (state is HealthGoalLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is HealthGoalLoaded) {
                  final goal = state.goal;
                  final targetWeight = goal.last.targetWeight;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        _showAndEditWeight(health, goal),
                        _lineChart(maxY, minY, targetWeight, health),
                        _bottomLineChart(bmi, avgWeight, lastWeight)
                      ],
                    ),
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

  Widget _showAndEditWeight(List<BmiEntity> health, List<BmiGoalEntity> goal) {
    final textCurrentStyle =
        TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
    final unitStyle = TextStyle(color: Colors.black, fontSize: 16);
    final weightCurrentStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
    final textGoalStyle =
        TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
    final weightGoalStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
    final iconEdit = Icon(
      Icons.edit,
      size: 14,
      color: Colors.grey,
    );

    final currentWeight = health.last.weight;
    final goalWeight = goal.last.targetWeight;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: BlocBuilder<HealthCubit, HealthState>(
            builder: (context, state) {
              return _formEdit(
                  'Current',
                  textCurrentStyle,
                  currentWeight,
                  weightCurrentStyle,
                  'kg',
                  unitStyle,
                  iconEdit,
                  CrossAxisAlignment.start,
                  MainAxisAlignment.start, () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ShowDialogCurrentForm(
                      weight: currentWeight,
                      title: 'Current Weight',
                    );
                  },
                ).then((value) {
                  if (!mounted) return;
                  setState(() {
                    _isPressedCurrent = true;
                  });
                  if (value == true) {
                    print('Refreshing data...');
                    context.read<HealthCubit>().getDataHealth();
                  }
                });
                setState(() {
                  _isPressedCurrent = !_isPressedCurrent;
                });
              }, _isPressedCurrent);
            },
          )),
          Expanded(child: BlocBuilder<HealthGoalCubit, HealthGoalState>(
            builder: (context, state) {
              return _formEdit(
                  'Goal',
                  textGoalStyle,
                  goalWeight,
                  weightGoalStyle,
                  'kg',
                  unitStyle,
                  iconEdit,
                  CrossAxisAlignment.end,
                  MainAxisAlignment.end, () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ShowDialogTargetForm(
                        weight: goalWeight, title: 'Target Weight');
                  },
                ).then((value) {
                  if (!mounted) return;
                  setState(() {
                    _isPressedGoal = true;
                  });
                  if (value == true) {
                    print('Refreshing data...');
                    context.read<HealthGoalCubit>().getHealGoal();
                  }
                });
                setState(() {
                  _isPressedGoal = !_isPressedGoal;
                });
              }, _isPressedGoal);
            },
          ))
        ],
      ),
    );
  }

  Widget _formEdit(
      String title,
      TextStyle textStyle,
      double weight,
      TextStyle weightStyle,
      String unit,
      TextStyle unitStyle,
      Icon icon,
      CrossAxisAlignment cross,
      MainAxisAlignment main,
      VoidCallback onTap,
      bool isPressed) {
    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: main,
              children: [
                Text(weight.toStringAsFixed(1),
                    style: isPressed
                        ? weightStyle
                        : weightStyle.copyWith(color: Colors.grey)),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  unit,
                  style: isPressed
                      ? unitStyle
                      : unitStyle.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  width: 4,
                ),
                icon,
              ],
            ))
      ],
    );
  }

  Widget _lineChart(
      double maxY, double minY, double targetWeight, List<BmiEntity> health) {
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          maxY: maxY,
          minY: minY,
          maxX: 30,
          minX: 5,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          extraLinesData: ExtraLinesData(horizontalLines: [
            HorizontalLine(
              y: maxY,
              color: Colors.grey,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: minY, //
              color: Colors.grey,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            HorizontalLine(
                y: targetWeight,
                color: Colors.transparent,
                strokeWidth: 0,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                    show: true,
                    alignment: const Alignment(-1, -0.5),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    labelResolver: (line) => '↓ Goal: ${targetWeight} kg')),
          ]),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value % 5 == 0 && value >= 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${value.toInt()}',
                          style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return Container();
                },
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var day in health.map((e) => e.createdAt!.day).toSet()) // toSet loại bỏ trùng lắp
                  FlSpot(
                      day.toDouble(),
                      health
                          .where((e) => e.createdAt!.day == day)
                          .reduce((a, b) => a.createdAt!.isAfter(b.createdAt!) ? a : b)
                          .weight
                  )
              ]..sort((a, b) => a.x.compareTo(b.x)),
              isCurved: true,
              gradient: const LinearGradient(colors: [
                AppColors.contentColorBlue,
                AppColors.contentColorCyan
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) => true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 2,
                  color: AppColors.white,
                  strokeWidth: 3,
                  strokeColor: AppColors.contentColorCyan,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.contentColorBlue.withOpacity(0.2),
                    AppColors.contentColorBlue.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomLineChart(double bmi, double avgWeight, double lastWeight) {
    const valueStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
    const titleStyle =
        TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
    var colorIndex = 0;
    List<Color> bmiColor = const [
      Color(0xff3A59D1),
      Color(0xff67AE6E),
      Color(0xffF5C45E),
      Color(0xffFE7743),
      Color(0xffF93827)
    ];
    if (bmi >= 18.5 && bmi < 24.9) {
      colorIndex = 1;
    }
    if (bmi >= 25.0 && bmi < 29.9) {
      colorIndex = 2;
    }
    if (bmi >= 30.0 && bmi < 34.9) {
      colorIndex = 3;
    }
    if (bmi >= 35 && bmi < 40.0) {
      colorIndex = 4;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last 7 Days',
                style: titleStyle,
              ),
              Text(
                  lastWeight < 0
                      ? '↑ ${lastWeight.toStringAsFixed(1)}'
                      : '↓ ${lastWeight.toStringAsFixed(1)}',
                  style: valueStyle),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avg',
                style: titleStyle,
              ),
              Text(
                avgWeight.toStringAsFixed(1),
                style: valueStyle,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI',
                style: titleStyle,
              ),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: bmiColor[colorIndex], shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    bmi.toStringAsFixed(1),
                    style: valueStyle,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

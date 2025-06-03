import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';
import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_state.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/personal/widget/form_edit_weight.dart';
import 'package:projectflutter/presentation/personal/widget/line_chart_item.dart';
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
  late ScrollController _scrollController;
  DateTime now = DateTime.now();
  bool _hasScrolled = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                  List<int> months = List.generate(12, (index) => index + 1);
                  double maxY = health.first.weight + 10;
                  double minY = health.first.weight - 15;
                  List<double> yTitles = [];
                  for (double y = maxY; y >= minY; y -= 5) {
                    yTitles.add(y);
                  }
                  double offset = (now.month - 1) * 300;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients  && !_hasScrolled) {
                      _scrollController.jumpTo(offset);
                      _hasScrolled = true;
                    }
                  });
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 34),
                          width: 40,
                          // height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(yTitles.length * 2, (index) {
                              if (index.isEven) {
                                double value = yTitles[index ~/ 2];
                                return Text(
                                  value.toStringAsFixed(0),
                                  style: TextStyle(fontSize: 10),
                                );
                              } else {
                                // index lẻ => là khoảng cách
                                return const SizedBox(height: 8); // khoảng cách giữa các dòng
                              }
                            }),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _showAndEditWeight(health, goal),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: months.length,
                                  itemBuilder: (context, index) {
                                    int month = months[index];
                                    List<BmiEntity> monthData = health
                                        .where((e) =>
                                            e.createdAt != null &&
                                            e.createdAt!.month == month &&
                                            e.createdAt!.year == now.year)
                                        .toList();

                                    int daysInMonth =
                                        DateTime(now.year, month + 1, 0).day;

                                    final formattedDate = DateFormat('MMM')
                                        .format(DateTime(now.year, month));
                                    return Container(
                                      width: 300,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LineChartItem(
                                              maxY: maxY,
                                              minY: minY,
                                              targetWeight: targetWeight,
                                              monthData: monthData,
                                              daysInMonth: daysInMonth,
                                              month: month,
                                              formattedDate: formattedDate),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              _bottomLineChart(bmi, avgWeight, lastWeight)
                            ],
                          ),
                        ),
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
    const textCurrentStyle =
        TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
    const unitStyle = TextStyle(color: Colors.black, fontSize: 16);
    const weightCurrentStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
    const textGoalStyle =
        TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
    const weightGoalStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
    const iconEdit = Icon(
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
              return FormEditWeight(
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
              return FormEditWeight(
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

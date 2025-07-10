import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_state.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/personal/widget/linechart/bottom_line_chart.dart';
import 'package:projectflutter/presentation/personal/widget/linechart/line_chart_item.dart';
import 'package:projectflutter/presentation/personal/widget/linechart/show_and_edit.dart';


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
  late ScrollController _scrollController;
  DateTime now = DateTime.now();
  bool _hasScrolled = false;
  late PageController _pageController;
  int _currentPageIndex = 0;
  int _currentTotalDays = 365;
  late final List<int> _years;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onHorizontalScroll);
    _years = [now.year - 1, now.year, now.year + 1];
    _pageController = PageController(
      initialPage: _years.indexOf(now.year),
    )..addListener(() {
      _currentPageIndex = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onHorizontalScroll);
    _scrollController.dispose();
    _pageController.dispose();
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
            DateTime? lastUpdateDate = health.last.createdAt;
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
                  final currentWeight = health.last.weight;
                  const double upperMargin = 10;
                  const double lowerMargin = 10;
                  double maxY = currentWeight + upperMargin;
                  double minY = currentWeight - lowerMargin;
                  List<double> yTitles = [];
                  for (double y = maxY; y >= minY; y -= 5) {
                    yTitles.add(y);
                  }
                  double offset = (now.month - 1) * 300;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients && !_hasScrolled) {
                      _scrollController.jumpTo(offset);
                      _hasScrolled = true;
                    }
                  });

                  final years = _years;
                  List<BmiEntity> dataOfYear(int year) => health
                      .where((e) =>
                          e.createdAt != null && e.createdAt!.year == year)
                      .toList()
                    ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
                  int daysInYear(int year) => DateTime(year + 1, 1, 1)
                      .difference(DateTime(year, 1, 1))
                      .inDays;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.gray.withOpacity(0.15),
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const ShowAndEdit(),
                        Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    List.generate(yTitles.length * 2, (index) {
                                  if (index.isEven) {
                                    double value = yTitles[index ~/ 2];
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                          fontSize:
                                              AppFontSize.textCustom(context)),
                                    );
                                  } else {
                                    return const SizedBox(height: 8);
                                  }
                                }),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 150,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: years.length,
                                  itemBuilder: (context, pageIndex) {
                                    final y = years[pageIndex];
                                    final listYearData = dataOfYear(y);
                                    final totalDays = daysInYear(y);
                                    _currentTotalDays = totalDays;
                                    final pct =
                                        (maxY - targetWeight) / (maxY - minY);
                                    final labelTop = pct * 150;

                                    return Stack(
                                      children: [
                                        SingleChildScrollView(
                                          controller: _scrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: SizedBox(
                                            width: totalDays * 10.0,
                                            height: 150,
                                            child: LineChartItem(
                                              year: y,
                                              yearData: listYearData,
                                              totalDays: totalDays,
                                              maxY: maxY,
                                              minY: minY,
                                              targetWeight: targetWeight,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 8,
                                          top: labelTop - 15,
                                          child: Text(
                                            '↓ Goal: ${targetWeight.toStringAsFixed(1)} kg',
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSize.valueLineChart(
                                                      context),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        BottomLineChart(
                            bmi: bmi,
                            avgWeight: avgWeight,
                            lastWeight: lastWeight,
                            lastUpdateDate: lastUpdateDate!)
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

  void _onHorizontalScroll() {
    if (!_scrollController.hasClients) return;
    final currentOffset = _scrollController.offset;
    final totalWidth = _currentTotalDays * 10.0;
    if (currentOffset >= totalWidth - 400) {
      if (_currentPageIndex < _years.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _resetScrollAfterPageChange();
      }
    } else if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0) {
      if (_currentPageIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _resetScrollAfterPageChange();
      }
    }
  }
  void _resetScrollAfterPageChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_scrollController.hasClients) return;

        final currentYear = _years[_currentPageIndex];
        final isCurrentYear = currentYear == now.year;

        final offset = isCurrentYear ? (now.month - 1) * 300.0 : 0.0;
        _scrollController.jumpTo(offset);
      });
    });
  }

}

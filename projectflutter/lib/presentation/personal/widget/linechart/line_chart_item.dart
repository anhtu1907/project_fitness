import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';

class LineChartItem extends StatelessWidget {
  final int year;
  final List<BmiEntity> yearData;
  final int totalDays;
  final double maxY, minY, targetWeight;

  const LineChartItem({
    super.key,
    required this.year,
    required this.yearData,
    required this.totalDays,
    required this.maxY,
    required this.minY,
    required this.targetWeight,
  });

  double dayOfYear(DateTime d) =>
      d.difference(DateTime(d.year, 1, 1)).inDays + 1;

  @override
  Widget build(BuildContext context) {
    final Map<int, BmiEntity> lastPerDay = {};
    for (var e in yearData) {
      if (e.createdAt == null) continue;
      final day = e.createdAt!.day;
      if (!lastPerDay.containsKey(day) ||
          lastPerDay[day]!.createdAt!.isBefore(e.createdAt!)) {
        lastPerDay[day] = e;
      }
    }

    final spots = lastPerDay.entries
        .map((entry) {
      final e = entry.value;
      return FlSpot(dayOfYear(e.createdAt!), e.weight);
    })
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final monthTicks = List.generate(12, (i) {
      final dt = DateTime(year, i + 1, 1);
      return MapEntry(dayOfYear(dt).toDouble(), DateFormat('MMM').format(dt));
    });

    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          maxY: maxY,
          minY: minY,
          maxX: totalDays.toDouble(),
          minX: 1,
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
                // label: HorizontalLineLabel(
                //     show: true,
                //     alignment: const Alignment(-1, -0.5),
                //     style: TextStyle(
                //         fontSize: AppFontSize.valueLineChart(context),
                //         color: Colors.grey,
                //         fontWeight: FontWeight.bold),
                //     labelResolver: (line) => '↓ Goal: $targetWeight kg')

            ),
          ]),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 0,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, _) {
                  final dayOfYear = value.round();
                  if (dayOfYear < 1 || dayOfYear > totalDays) {
                    return const SizedBox.shrink();
                  }
                  final date = DateTime(year, 1, 1)
                      .add(Duration(days: dayOfYear - 1));
                  final dayOfMonth = date.day;
                  const bottomLabels = [1, 5,10, 15, 20, 25];
                  if (!bottomLabels.contains(dayOfMonth)) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$dayOfMonth',
                      style: TextStyle(
                        fontSize: AppFontSize.valueLineChart(context),
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: 1,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final m = monthTicks.firstWhere(
                      (e) => (e.key - value).abs() < 0.5,
                  orElse: () => const MapEntry(-1, ''),
                );
                if (m.key > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      m.value,
                      style: TextStyle(
                        fontSize: AppFontSize.value10Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots.isNotEmpty ? spots : [],
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
                    AppColors.contentColorBlue.withOpacity(0.8),
                    AppColors.contentColorBlue.withOpacity(0.2),
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
}

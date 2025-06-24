import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';

class LineChartItem extends StatelessWidget {
  const LineChartItem(
      {super.key,
      required this.maxY,
      required this.minY,
      required this.targetWeight,
      required this.monthData,
      required this.daysInMonth,
      required this.month,
      required this.formattedDate});
  final double maxY;
  final double minY;
  final double targetWeight;
  final List<BmiEntity> monthData;
  final int daysInMonth;
  final int month;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = monthData.isNotEmpty
        ? ([
            for (var day in monthData.map((e) => e.createdAt!.day).toSet())
              FlSpot(
                day.toDouble(),
                monthData
                    .where((e) => e.createdAt!.day == day)
                    .reduce((a, b) => (a.createdAt?.isAfter(b.createdAt ??
                                DateTime.fromMillisecondsSinceEpoch(0)) ??
                            false)
                        ? a
                        : b)
                    .weight,
              )
          ]..sort((a, b) => a.x.compareTo(b.x)))
        : [];
    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          maxY: maxY,
          minY: minY,
          maxX: daysInMonth.toDouble(),
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
                showTitles: false,
                reservedSize: 2,
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
                  if (value >= 1 && value <= 25) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${value.toInt()}',
                          style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return Container();
                },
                interval: 5,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      formattedDate,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return SizedBox.shrink();
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

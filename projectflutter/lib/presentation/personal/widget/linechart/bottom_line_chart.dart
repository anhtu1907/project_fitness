import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class BottomLineChart extends StatelessWidget {
  final double bmi;
  final double avgWeight;
  final double lastWeight;
  final DateTime lastUpdateDate;

  const BottomLineChart({
    Key? key,
    required this.bmi,
    required this.avgWeight,
    required this.lastWeight,
    required this.lastUpdateDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var valueStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.value20Text(context),
    );
    const titleStyle = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
    );

    // Determine BMI color index
    int colorIndex = 0;
    List<Color> bmiColor = const [
      Color(0xff3A59D1),
      Color(0xff67AE6E),
      Color(0xffF5C45E),
      Color(0xffFE7743),
      Color(0xffF93827),
    ];
    if (bmi >= 18.5 && bmi < 24.9) colorIndex = 1;
    if (bmi >= 25.0 && bmi < 29.9) colorIndex = 2;
    if (bmi >= 30.0 && bmi < 34.9) colorIndex = 3;
    if (bmi >= 35.0 && bmi < 40.0) colorIndex = 4;

    // Reset lastWeight if data is older than 7 days
    final daysSince = DateTime.now().difference(lastUpdateDate).inDays;
    final displayLastWeight = daysSince > 7 ? 0.0 : lastWeight;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Last 7 Days
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Last 7 Days', style: titleStyle),
              Text(
                displayLastWeight == 0
                    ? '0.0'
                    : (displayLastWeight < 0
                    ? '↑ ${displayLastWeight.abs().toStringAsFixed(1)}'
                    : '↓ ${displayLastWeight.abs().toStringAsFixed(1)}'),
                style: valueStyle,
              ),
            ],
          ),

          // Average Weight
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Avg', style: titleStyle),
              Text(
                avgWeight.toStringAsFixed(1),
                style: valueStyle,
              ),
            ],
          ),

          // BMI
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('BMI', style: titleStyle),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: bmiColor[colorIndex],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    bmi.toStringAsFixed(1),
                    style: valueStyle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

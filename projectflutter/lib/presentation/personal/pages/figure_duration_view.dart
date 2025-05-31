import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/personal/widget/data_bar_chart_figure_duration.dart';
import 'package:projectflutter/presentation/personal/widget/data_line_chart_duration.dart';

class FigureDurationView extends StatelessWidget {
  const FigureDurationView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String monthName = DateFormat.MMM().format(now);
    final formattedDate = '$monthName ${now.year}';
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Figures Duration'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const DataLineChartDuration(),
              const SizedBox(
                height: 20,
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const DataBarChartFigureDuration()
            ],
          ),
        ),
      ),
    );
  }
}

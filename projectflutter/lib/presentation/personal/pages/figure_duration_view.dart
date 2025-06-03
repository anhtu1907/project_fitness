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
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Figures Duration'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: AppColors.backgroundColor,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DataLineChartDuration(),
              SizedBox(
                height: 20,
              ),
              DataBarChartFigureDuration()
            ],
          ),
        ),
      ),
    );
  }
}

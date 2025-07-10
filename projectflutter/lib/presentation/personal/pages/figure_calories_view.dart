import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/personal/widget/barchart/data_bar_chart_figure_calories.dart';
import 'package:projectflutter/presentation/personal/widget/linechart/data_line_chart_calories.dart';

class FigureCaloriesView extends StatelessWidget {
  const FigureCaloriesView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Figures Calories',
            style: TextStyle(
                fontSize: AppFontSize.titleAppBar(context),
                fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: AppColors.backgroundColorWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const DataLineChartCalories(),
              SizedBox(
                height: media.height * 0.02,
              ),
              const DataBarChartFigureCalories()
            ],
          ),
        ),
      ),
    );
  }
}

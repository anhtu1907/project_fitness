import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/personal/widget/barchart/data_bar_chart_calories_absorption.dart';
import 'package:projectflutter/presentation/personal/widget/barchart/data_bar_chart_calories.dart';
import 'package:projectflutter/presentation/personal/widget/barchart/data_bar_chart_duration.dart';
import 'package:projectflutter/presentation/personal/widget/linechart/data_line_chart.dart';
import 'package:projectflutter/presentation/personal/widget/data_progress_calories_absorption.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: BasicAppBar(
            hideBack: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Personal Daily', style: TextStyle(fontSize: AppFontSize.heading2(context))),
                SizedBox(
                  width: media.width * 0.02,
                ),
                FaIcon(
                  FontAwesomeIcons.database,
                  color: AppColors.iconColor,
                )
              ],
            )),
        backgroundColor: AppColors.backgroundColorWhite,
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Weight', style: TextStyle(fontSize: AppFontSize.body(context), fontWeight: FontWeight.bold),),
                  SizedBox(height: media.height * 0.02,),
                  const DataLineChart(),
                  SizedBox(height: media.height * 0.02,),
                  Text('This Week', style: TextStyle(fontSize: AppFontSize.body(context), fontWeight: FontWeight.bold),),
                  SizedBox(height: media.height * 0.02,),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: DataBarChartDuration()),
                          SizedBox(width: media.width * 0.04,),
                          const Expanded(child: DataBarChartCalories())
                        ],
                      ),
                      SizedBox(height: media.height * 0.02,),
                      Row(
                        children: [
                          const Expanded(child: DataBarChartCalorieAbsorption()),
                          SizedBox(width: media.width * 0.04,),
                          const Expanded(child: DataProgressCaloriesAbsorption())
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
  }
}

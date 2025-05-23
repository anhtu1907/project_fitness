import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/personal/widget/data_bar_chart_calories.dart';
import 'package:projectflutter/presentation/personal/widget/data_bar_chart_duration.dart';
import 'package:projectflutter/presentation/personal/widget/data_line_chart.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppBar(
            hideBack: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Personal Daily'),
                const SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.database,
                  color: AppColors.iconColor,
                )
              ],
            )),
        backgroundColor: AppColors.backgroundColor,
        body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  // DataLineChart(),
                   SizedBox(height: 20,),
                  Text('This Week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: DataBarChartDuration()),
                      SizedBox(width: 10,),
                      Expanded(child: DataBarChartCalories())
                    ],
                  )
                ],
              ),
            ),
          ),
        );
  }
}

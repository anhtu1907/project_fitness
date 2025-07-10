import 'package:flutter/material.dart';

class AppFontSize{
  static double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 375;
  }
  // Size 30
  static double weightCurrentText(BuildContext context) => 30 * scale(context);
  static double value30Text(BuildContext context) => 30 * scale(context);
  // Size 28
  static double heading1(BuildContext context) => 28 * scale(context);
  static double value28Text(BuildContext context) => 28 * scale(context);
  // Size 24
  static double heading2(BuildContext context) => 24 * scale(context);
  static double value24Text(BuildContext context) => 24 * scale(context);
  // Size 22
  static double tabIcon(BuildContext context) => 22 * scale(context);
  static double value22Text(BuildContext context) => 22 * scale(context);
  // Size 20
  static double buttonText(BuildContext context) => 20 * scale(context);
  static double nameText(BuildContext context) => 20 * scale(context);
  static double welcomeText(BuildContext context) => 20 * scale(context);
  static double descriptionText(BuildContext context) => 20 * scale(context);
  static double weightGoalText(BuildContext context) => 20 * scale(context);
  static double value20Text(BuildContext context) => 20 * scale(context);

  // Size 18
  static double titleAppBar(BuildContext context) => 18 * scale(context);
  static double mealItemSchedule(BuildContext context) => 18 * scale(context);
  static double value18Text(BuildContext context) => 18 * scale(context);
  // Size 16
  static double body(BuildContext context) => 16 * scale(context);
  static double value16Text(BuildContext context) => 16 * scale(context);
  static double titleBody(BuildContext context) => 16 * scale(context);
  static double titleScheduleMeal(BuildContext context) => 16 * scale(context);
  static double questionText(BuildContext context) => 16 * scale(context);
  // Size 14
  static double caption(BuildContext context) => 14 * scale(context);
  static double iconLineChart(BuildContext context) => 14 * scale(context);
  static double value14Text(BuildContext context) => 14 * scale(context);
  // Size 13.5
  static double textCustom(BuildContext context) => 13.5 * scale(context);
  static double value135Text(BuildContext context) => 13.5 * scale(context);
  // Size 13
  static double value13Text(BuildContext context) => 13 * scale(context);
  static double subTitleAppBar(BuildContext context) => 13 * scale(context);
  // Size 12
  static double content(BuildContext context) => 12 * scale(context);
  static double value12Text(BuildContext context) => 13 * scale(context);
  // Size 11
  static double value11Text(BuildContext context) => 11 * scale(context);
  // Size 10
  static double valueLineChart(BuildContext context) => 10 * scale(context);
  static double value10Text(BuildContext context) => 10 * scale(context);
}
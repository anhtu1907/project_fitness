import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xff1D182A);
  static const secondDarkBackground = Color(0xff342F3F);
  static const secondLightBackground = Colors.white;

  static Color get iconColor => const Color(0xffF93827);
  static Color get backgroundColor =>  Colors.grey.shade100;
  static Color get backgroundColorWhite=>  Colors.white;

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF90C67C);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);

  static Color get primaryBottomBar => const Color(0xff6B7AFD);
  // BMI Status
  static Color get underweight => const Color(0xff3A59D1);
  static Color get normalweight => const Color(0xff67AE6E);
  static Color get overweight => const Color(0xffF5C45E);
  static Color get obesity => const Color(0xffFE7743);
  static Color get obesitysecond => const Color(0xffF93827);
  // Workout
  static List<Color> get primaryGWorkout => [primaryWorkout, primaryWorkout];
  static Color get primaryWorkout => const Color(0xffFF9B70);
  static Color get primaryTextWorkout => const Color(0xff221E3A);
  static Color get secondaryTextWorkout => const Color(0xff707070);
  static Color get greenWorkout => const Color(0xff77E517);

  static Color get whiteWorkout => Colors.white;
  static Color get grayWorkout => const Color(0xff8C8C8C);
  static Color get dividerWorkout => const Color(0xffE1E1E1);
  // Time of Day Pie Chart
  static Color get morning => const Color(0xff98D8EF);
  static Color get afternoon => const Color(0xffFFA55D);
  static Color get evening => const Color(0xff3D365C);

  // Line Chart
  static const Color mainGridLineColor = Colors.white10;

  // Bar Chart
  static Color get durationChart => const Color(0xff92A3FD);
  static Color get durationBottomTitle => const Color(0xff92A3FD);
  static Color get caloriesChart => const Color(0xffFE7743);
  static Color get caloriesBottomTitle => const Color(0xffFE7743);
  static Color get absorptionChart => const Color(0xFF90C67C);
  static Color get absorptionBottomTitle => const Color(0xFF90C67C);
  static List<Color> get dotGradient => [contentColorCyan, contentColorBlue];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get backgroundAuth => const Color(0xffC4D9FF);
  static Color get lightGray => const Color(0xffF7F8F8);

  // Primary

  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get primaryColor3 => const Color(0xff0D5EA6);
  static Color get primaryColor4 => const Color(0xff578FCA);

  static Color get kcalColor => const Color(0xFFF7374F);

  // Secondary
  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);
  // Gradient
  static List<Color> get primaryG => [primaryColor2, primaryColor1,];
  static List<Color> get primaryGFavoriteCard => [primaryColor3, primaryColor4,];
  static List<Color> get primaryGButton => [primaryColor3, primaryColor4,];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];
  static List<Color> get warningG => [obesitysecond, Colors.red];
}

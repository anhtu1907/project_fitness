import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class AppTheme {
  static final darkThem = ThemeData(
      primaryColor: AppColors.primaryColor1,
      scaffoldBackgroundColor: AppColors.secondDarkBackground,
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        labelSmall: TextStyle(color: Colors.black, fontSize: 16),
        labelMedium: TextStyle(color: Colors.black, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondLightBackground,
        hintStyle: const TextStyle(
            color: Color(0xffA7A7A7), fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blue, width: 3),
        ),
      ));

  static final lightTheme = ThemeData(
      primaryColor: AppColors.primaryColor1,
      scaffoldBackgroundColor: AppColors.secondLightBackground,
      brightness: Brightness.light,
      textTheme: const TextTheme(
        labelSmall: TextStyle(color: Colors.black, fontSize: 16),
        labelMedium: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGray,
        hintStyle: const TextStyle(
            color: Color(0xffA7A7A7), fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.black)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.blue, width: 3),
        ),
      ));
}

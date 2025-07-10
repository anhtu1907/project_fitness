import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class TitleSubTitleCellKcal extends StatelessWidget {
  final double value;
  final String subtitle;

  const TitleSubTitleCellKcal(
      {super.key, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${value.toStringAsFixed(0)} Kcal',
            style: TextStyle(
                color: AppColors.primaryColor1,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.black, fontSize: 15),
          )
        ],
      ),
    );
  }
}

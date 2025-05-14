import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class TitleSubtitleCellDouble extends StatelessWidget {
  final double value;
  final String subtitle;
  final String unit;

  const TitleSubtitleCellDouble(
      {super.key,
      required this.value,
      required this.subtitle,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: TextStyle(
                color: AppColors.primaryColor1,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.black, fontSize: 14),
          )
        ],
      ),
    );
  }
}

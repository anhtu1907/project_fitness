import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class TitleSubtitleCell extends StatelessWidget {
  final dynamic value;
  final String subtitle;
  final String unit;

  const TitleSubtitleCell(
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)]),
      child: Column(
        children: [
          Text(
            '$value $unit',
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

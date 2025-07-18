import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class TitleSubTitleCellTimeResult extends StatelessWidget {
  final dynamic value;
  final String subtitle;

  const TitleSubTitleCellTimeResult(
      {super.key, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final duration = Duration(seconds: seconds);
      return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(
        children: [
          Text(
            _formatDuration(value),
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

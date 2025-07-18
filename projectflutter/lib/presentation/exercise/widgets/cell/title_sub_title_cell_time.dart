import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class TitleSubTitleCellTime extends StatelessWidget {
  final dynamic value;
  final String subtitle;

  const TitleSubTitleCellTime(
      {super.key, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          right: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatDuration(value),
            style: TextStyle(
                color: AppColors.primaryColor1,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSize.value16Text(context)),
          ),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.black, fontSize: AppFontSize.value14Text(context)),
          )
        ],
      ),
    );
  }
}

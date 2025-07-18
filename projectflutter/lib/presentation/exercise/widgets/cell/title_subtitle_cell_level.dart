import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class TitleSubtitleCellLevel extends StatelessWidget {
  final dynamic value;
  final String subtitle;

  const TitleSubtitleCellLevel(
      {super.key, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            value,
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

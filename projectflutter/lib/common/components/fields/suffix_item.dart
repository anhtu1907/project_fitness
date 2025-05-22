import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class SuffixItem extends StatelessWidget {
  final String? suffixText;
  const SuffixItem({super.key, required this.suffixText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppColors.secondaryG),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        suffixText!,
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

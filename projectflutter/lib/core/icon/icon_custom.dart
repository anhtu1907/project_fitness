import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class IconCustom extends StatelessWidget {
  const IconCustom({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: AppColors.gray, size: 25);
  }
}

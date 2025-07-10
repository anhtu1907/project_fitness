import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class BasicButton extends StatelessWidget {
  const BasicButton({super.key, required this.title, required this.onPressed, this.width = 300});
  final String title;
  final VoidCallback onPressed;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // margin: const EdgeInsets.only(right: 16),
        width: width,
        height: 50,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor1,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}

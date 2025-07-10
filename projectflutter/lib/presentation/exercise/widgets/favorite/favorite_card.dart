import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class FavoriteCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const FavoriteCard({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final width = media.width * 0.5;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor3.withOpacity(0.5),
                  AppColors.primaryColor4.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: AppColors.contentColorWhite,
                  size: 24,
                ),
                SizedBox(width: media.width * 0.02),
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: AppFontSize.value16Text(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.contentColorWhite,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

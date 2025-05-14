import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class ExerciseSubcategoryRow extends StatelessWidget {
  final String image;
  final String name;
  final String duration;
  final String level;
  final VoidCallback onPressed;

  const ExerciseSubcategoryRow(
      {super.key,
      required this.image,
      required this.name,
      required this.duration,
      required this.level,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Flexible(
              child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    name,
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$duration mins | ',
                      style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$level ',
                      style: TextStyle(color: AppColors.gray, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

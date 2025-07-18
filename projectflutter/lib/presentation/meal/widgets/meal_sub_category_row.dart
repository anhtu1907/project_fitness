import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class MealSubCategoryRow extends StatelessWidget {
  final String image;
  final String name;
  final double kcal;
  final int totalFood;
  final VoidCallback onPressed;

  const MealSubCategoryRow(
      {super.key,
      required this.image,
      required this.name,
      required this.kcal,
      required this.totalFood,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            child: SwitchImageType.buildImage(
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
                      '${kcal.toStringAsFixed(1)} Kcal | ',
                      style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$totalFood foods',
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

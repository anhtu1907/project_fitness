import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class ExerciseEquipmentItem extends StatelessWidget {
  final String image;
  final String equipmentName;
  const ExerciseEquipmentItem(
      {super.key, required this.image, required this.equipmentName});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xff91C8E4).withOpacity(0.1),
          border: Border.all(color: AppColors.black.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SwitchImageType.buildImage(
              image,
              fit: BoxFit.cover,
              width: media.width * 0.07,
              height: media.height * 0.035,
            ),
          ),
          SizedBox(width: media.width * 0.02),
          Text(
            equipmentName,
            style: TextStyle(
              fontSize: AppFontSize.caption(context),
              height: 1,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class SettingRow extends StatelessWidget {
  final String imageIcon;
  final String title;
  final VoidCallback onPressed;

  const SettingRow(
      {super.key,
      required this.imageIcon,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 32,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SwitchImageType.buildImage(
              imageIcon,
              height: 15,
              width: 15,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Text(
              title,
              style: TextStyle(color: AppColors.black, fontSize: 12),
            )),
            SwitchImageType.buildImage(
              AppImages.pNext,
              height: 12,
              width: 12,
              fit: BoxFit.contain,
            )
          ],
        ),
      ),
    );
  }
}

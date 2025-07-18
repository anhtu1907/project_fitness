import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';

class AvatarItem extends StatelessWidget {
  final UserEntity user;
  const AvatarItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: SwitchImageType.buildImage(
          user.gender == 1 ? AppImages.male : AppImages.female,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ));
  }
}

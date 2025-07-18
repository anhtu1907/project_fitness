import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class ExerciseSubCategoryFavoriteRow extends StatefulWidget {
  final String image;
  final String name;
  final String duration;
  final String level;
  final VoidCallback onPressed;

  const ExerciseSubCategoryFavoriteRow(
      {super.key,
      required this.image,
      required this.name,
      required this.duration,
      required this.level,
      required this.onPressed});

  @override
  State<ExerciseSubCategoryFavoriteRow> createState() =>
      _ExerciseSubCategoryFavoriteRowState();
}

class _ExerciseSubCategoryFavoriteRowState
    extends State<ExerciseSubCategoryFavoriteRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              child: SwitchImageType.buildImage(
            widget.image,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          )),
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
                    widget.name,
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
                      '${widget.duration} mins | ',
                      style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.level} ',
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

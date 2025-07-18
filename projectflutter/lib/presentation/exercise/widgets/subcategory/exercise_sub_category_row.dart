import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

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
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            radius: media.width * 0.08,
            backgroundImage: NetworkImage(image),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: media.width * 0.05,
          ),
          Flexible(
              child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: media.width * 0.8,
                  child: Text(
                    name,
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.value16Text(context),
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
                          fontSize: AppFontSize.value14Text(context),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$level',
                      style: TextStyle(
                        color: AppColors.gray,
                        fontSize: AppFontSize.value14Text(context),
                      ),
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

import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_item_trait.dart';

class ExerciseSubCategoryCard extends StatelessWidget {
  final String name;
  final int subCategoryId;
  final String subName;
  final String image;
  final String level;
  final int duration;
  final int totalWorkout;
  const ExerciseSubCategoryCard(
      {super.key,
      required this.name,
      required this.subCategoryId,
      required this.level,
      required this.subName,
      required this.duration,
      required this.totalWorkout,
      required this.image});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            ExerciseBySubCategoryView(
              subCategoryId: subCategoryId,
              level: level,
              image: image,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.gray,
            border: Border.all(color: AppColors.gray.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(30)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
                child: SwitchImageType.buildImage(
              image,
              fit: BoxFit.cover,
            )),
            Positioned.fill(
                child: Container(
              color: Colors.black.withOpacity(0.1),
            )),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: ExerciseItemTrait(
                  categoryName: name,
                  totalWorkout: totalWorkout,
                  duration: _formatDuration(duration)),
            ),
          ],
        ),
      ),
    );
  }
}

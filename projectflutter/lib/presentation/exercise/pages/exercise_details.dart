import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/data/exercises_image.dart';
import 'package:projectflutter/core/data/exercises_image_gif.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:readmore/readmore.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final ExercisesEntity exercises;
  const ExerciseDetailsPage({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: BasicAppBar(
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: media.width,
                        height: media.width * 0.43,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.network(
                          exerciseImageMap[exercises.id].toString(),
                          width: media.width,
                          height: media.width * 0.43,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        exercises.exerciseName,
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: media.width * 0.01,
                      ),
                      Text(
                        '${exercises.subCategory!.subCategoryName} | ${exercises.kcal.toStringAsFixed(0)} Calories Burn',
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        "Descriptions",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: media.width * 0.01,
                      ),
                      ReadMoreText(
                        exercises.description,
                        trimLines: 4,
                        colorClickableText: AppColors.black,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Read More ...',
                        trimExpandedText: ' Read Less',
                        style: TextStyle(
                          color: AppColors.gray,
                          fontSize: 14,
                        ),
                        moreStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      ExtendedImage.network(
                        exerciseGIF[exercises.id].toString(),
                        fit: BoxFit.cover,
                        enableLoadState: false,
                        width: double.infinity,
                      )
                    ]))));
  }
}

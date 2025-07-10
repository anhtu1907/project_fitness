import 'package:flutter/material.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/exercise/entity/equipments_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_favorite.dart';
import 'package:projectflutter/domain/exercise/usecase/remove_exercise_favorite.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_details.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_equipment_item.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercises_row.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/select_date_schedule.dart';
import 'package:projectflutter/presentation/exercise/widgets/show/show_dialog_list_favorite.dart';
import 'package:projectflutter/presentation/exercise/widgets/cell/title_sub_title_cell_kcal.dart';
import 'package:projectflutter/presentation/exercise/widgets/cell/title_sub_title_cell_time.dart';
import 'package:projectflutter/presentation/exercise/widgets/cell/title_subtitle_cell_level.dart';
import 'package:readmore/readmore.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseSubCategoryDetails extends StatefulWidget {
  final int subCategoryId;
  final String subCategoryName;
  final String description;
  final String level;
  final int totalDuration;
  final double kcal;
  final int totalExercise;
  final String image;
  final List<ExercisesEntity> exercises;
  final List<EquipmentsEntity> equipments;

  const ExerciseSubCategoryDetails(
      {super.key,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.description,
      required this.level,
      required this.totalDuration,
      required this.exercises,
      required this.kcal,
      required this.image,
      required this.totalExercise,
      required this.equipments});

  @override
  State<ExerciseSubCategoryDetails> createState() =>
      _ExerciseSubCategoryDetailsState();
}

class _ExerciseSubCategoryDetailsState
    extends State<ExerciseSubCategoryDetails> {
  bool _isSaveFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final favoriteIdStrings = SharedPreferenceService.favoriteIds;
    final favoriteIds = favoriteIdStrings!
        .map((e) => int.tryParse(e))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
    final results = await Future.wait(
      favoriteIds
          .map((id) => sl<GetExerciseFavoriteUseCase>().call(params: id)),
    );

    bool found = false;

    for (final eitherResult in results) {
      eitherResult.fold(
        (failure) => null,
        (list) {
          if (list.any((e) => e.subCategory?.id == widget.subCategoryId)) {
            found = true;
          }
        },
      );
      if (found) break;
    }

    if (mounted) {
      setState(() {
        _isSaveFavorite = found;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: false,
              expandedHeight: media.width * 0.5,
              automaticallyImplyLeading: false,
              flexibleSpace: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.subCategoryName,
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (!_isSaveFavorite) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ShowDialogListFavorite(
                                        subCategoryId: widget.subCategoryId);
                                  },
                                ).then((result) {
                                  if (mounted && result == true) {
                                    setState(() {
                                      _isSaveFavorite = true;
                                    });
                                  }
                                });
                              } else {
                                _removeFavorite();
                              }
                            },
                            icon: _isSaveFavorite
                                ? const Icon(Icons.star,
                                    color: Colors.orange, size: 35)
                                : const Icon(Icons.star_border_outlined,
                                    size: 35),
                          )
                        ],
                      )),
                  SizedBox(
                    height: media.width * 0.01,
                  ),
                  _subTitle(widget.level, widget.totalDuration, widget.kcal),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  SelectDateSchedule(
                    icon: "assets/images/time.png",
                    title: "Schedule Workout",
                    subCategoryId: widget.subCategoryId,
                    color: AppColors.primaryColor2,
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  if (widget.equipments.isNotEmpty) ...[
                    const Text(
                      'Equipment',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Wrap(
                      spacing: 15,
                      children: widget.equipments.map((equipment) {
                        return ExerciseEquipmentItem(
                          image: equipment.equipmentImage,
                          equipmentName: equipment.equipmentName,
                        );
                      }).toList(),
                    )
                  ],
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  ReadMoreText(
                    widget.description,
                    trimLines: 4,
                    colorClickableText: AppColors.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Read More ...',
                    trimExpandedText: ' Read Less',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: 16,
                    ),
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Row(
                    children: [
                      Text(
                        "Exercises",
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '( ${widget.totalExercise.toString()} )',
                        style: TextStyle(color: AppColors.gray, fontSize: 12),
                      )
                    ],
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 70.0),
                    shrinkWrap: true,
                    itemCount: widget.exercises.length,
                    itemBuilder: (context, index) {
                      return ExercisesRow(
                          image: widget.exercises[index].exerciseImage,
                          name: widget.exercises[index].exerciseName,
                          duration: widget.exercises[index].duration,
                          onPressed: () {
                            AppNavigator.push(
                                context,
                                ExerciseDetailsPage(
                                    exercises: widget.exercises[index]));
                          });
                    },
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _subTitle(String level, int duration, double kcal) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: TitleSubtitleCellLevel(value: level, subtitle: "Level")),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            flex: 3,
            child: TitleSubTitleCellTime(value: duration, subtitle: "Times")),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 4,
          child: TitleSubTitleCellKcal(
            value: kcal,
            subtitle: "Calories",
          ),
        ),
      ],
    );
  }

  void _removeFavorite() async {
    sl<RemoveExerciseFavoriteUseCase>().call(params: widget.subCategoryId);
    print('SubCategory ID: ${widget.subCategoryId}');
    setState(() {
      _isSaveFavorite = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exercise removed from your favorites")),
    );
  }
}

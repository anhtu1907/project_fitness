import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/widgets/category/exercise_category_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/search/exercise_search_field.dart';
import 'package:projectflutter/presentation/exercise/widgets/favorite/favorites.dart';
import 'package:projectflutter/presentation/exercise/widgets/category/exercise_list_category_popular.dart';
import 'package:projectflutter/presentation/exercise/widgets/others/exercise_sections.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Exercises',
                style: TextStyle(fontSize: AppFontSize.heading2(context))),
            SizedBox(
              width: media.width * 0.02,
            ),
            FaIcon(
              FontAwesomeIcons.personRunning,
              color: AppColors.iconColor,
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExerciseSearchField(),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseCategoryList(),
              SizedBox(
                height: media.width * 0.05,
              ),
              Text(
                'Popular Workout',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.body(context),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseListCategoryPopular(),
              const Favorites(),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseSections(),
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_category_list.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_schedule_check.dart';
import 'package:projectflutter/presentation/meal/widgets/search/meal_search_field.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_type_list.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BasicAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Meals', style: TextStyle(fontSize: AppFontSize.heading2(context)),),
            SizedBox(
              width: media.width * 0.02,
            ),
            FaIcon(
              FontAwesomeIcons.bowlFood,
              color: AppColors.iconColor,
            )
          ],
        ),
        hideBack: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MealSearchField(),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  const MealScheduleCheck(),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    'Category',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.titleBody(context),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  const MealCategoryList(),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  const MealTypeList()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

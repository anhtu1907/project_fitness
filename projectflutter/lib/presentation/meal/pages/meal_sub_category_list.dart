import 'package:flutter/material.dart';

import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_sub_category_card.dart';

class MealSubCategoryListPage extends StatelessWidget {
  final List<MealSubCategoryEntity> total;
  final String categoryName;
  final Map<String, double> kcal;
  final Map<String, int> totalFood;

  const MealSubCategoryListPage(
      {super.key,
      required this.total,
      required this.categoryName,
      required this.kcal,
      required this.totalFood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(categoryName, style: TextStyle(
            fontSize: AppFontSize.titleAppBar(context),
            fontWeight: FontWeight.w700)),
        subTitle: Text(
          '${total.length} meals',
          style: TextStyle(
              color: AppColors.gray,
              fontSize: AppFontSize.subTitleAppBar(context),
              fontWeight: FontWeight.w500),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: ListView.builder(
            itemCount: total.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: MealSubCategoryCard(
                    subCategoryId: total[index].id,
                    subCategoryName: total[index].subCategoryName,
                    description: total[index].description,
                    kcal: kcal[total[index].subCategoryName] ?? 0,
                    totalFood: totalFood[total[index].subCategoryName] ?? 0),
              );
            },
          )),
    );
  }
}

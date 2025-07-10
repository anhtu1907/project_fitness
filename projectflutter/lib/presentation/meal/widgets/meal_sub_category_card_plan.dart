import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/meal_sub_category.dart';
import 'package:projectflutter/data/meal/request/user_meal_request.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_sub_category.dart';
import 'package:projectflutter/domain/meal/usecase/save_record_meal.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/meal/pages/meal_by_sub_category.dart';

class MealSubCategoryCardPlan extends StatelessWidget {
  final int subCategoryId;
  final String subCategoryName;
  final String description;
  final double kcal;
  final int totalFood;

  const MealSubCategoryCardPlan(
      {super.key,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.description,
      required this.kcal,
      required this.totalFood});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        AppNavigator.push(
            context,
            MealBySubCategory(
              subCategoryId: subCategoryId,
              categoryName: subCategoryName,
            ));
      },
      child: Container(
        height: media.width * 0.55,
        decoration: BoxDecoration(
            color: AppColors.gray, borderRadius: BorderRadius.circular(30)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                mealSubCategoryImage[subCategoryId].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration:
                    BoxDecoration(color: AppColors.black.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subCategoryName,
                      style: TextStyle(
                          color: AppColors.primaryColor1,
                          fontSize: AppFontSize.caption(context),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppFontSize.descriptionText(context),
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: media.height * 0.01,),
                    IntrinsicWidth(
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // RẤT QUAN TRỌNG
                          children: [
                            Text(
                              '${kcal.toStringAsFixed(0)} Kcal | ',
                              style: TextStyle(
                                color: AppColors.kcalColor,
                                fontSize: AppFontSize.caption(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$totalFood foods',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppFontSize.caption(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: media.width * 0.3,
                            height: media.height * 0.05,
                            child: RoundButton(
                              title: "Add Plan",
                              fontSize: AppFontSize.caption(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              onPressed: () async {
                                final getMeals = GetMealBySubCategoryUseCase();
                                final result =
                                    await getMeals.call(params: subCategoryId);
                                result.fold((err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $err')));
                                }, (data) async {
                                  final List<MealsEntity> meals =
                                      List<MealsEntity>.from(data);
                                  List<int> mealIds =
                                      meals.map((meal) => meal.id).toList();
                                  DateTime now = DateTime.now();
                                  DateTime today =
                                      DateTime(now.year, now.month, now.day);

                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: today,
                                    firstDate: today,
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    final created = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      now.hour,
                                      now.minute,
                                      now.second,
                                    );
                                    final req = UserMealRequest(
                                      user: SharedPreferenceService.userId!,
                                      meal: mealIds,
                                      created: created,
                                    );

                                    final saveMeal = SaveRecordMealUseCase();
                                    await saveMeal.call(params: req);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Meal plan scheduled successfully.'),
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                            )),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

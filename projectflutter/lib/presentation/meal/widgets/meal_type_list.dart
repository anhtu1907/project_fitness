import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_card.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/pages/meal_sub_category_list.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_sub_category_plan_list.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_sub_category_card_plan.dart';

class MealTypeList extends StatelessWidget {
  const MealTypeList({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MealSubCategoryCubit()..listSubCategory(),
          ),
          BlocProvider(
            create: (context) => MealsCubit()..listMeal(),
          )
        ],
        child: BlocBuilder<MealsCubit, MealsState>(builder: (context, state) {
          if (state is MealsLoaing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoadMealsFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is MealsLoaded) {
            final allMeals = state.entity;
            Map<String, List<MealsEntity>> groupedSubCategory = {};
            for (var meal in allMeals) {
              for (var sub in meal.subCategory) {
                final subCategoryName = sub.subCategoryName;
                groupedSubCategory
                    .putIfAbsent(subCategoryName, () => [])
                    .add(meal);
              }
            }
            Map<String, double> kcalBySubCategory = {};
            groupedSubCategory.forEach((subCatName, foods) {
              kcalBySubCategory[subCatName] =
                  foods.fold(0, (sum, item) => sum += item.kcal);
            });

            Map<String, int> foodBySubCategory = {};
            groupedSubCategory.forEach((subCatName, foods) {
              foodBySubCategory[subCatName] = foods.length;
            });
            return BlocBuilder<MealSubCategoryCubit, MealSubCategoryState>(
                builder: (context, state) {
              if (state is MealSubCategoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadMealSubCategoryFailure) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              if (state is MealSubCategoryLoaded) {
                final subCategories = state.entity;
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleRow(context, 'Goal', subCategories, 'Meal Goal',
                          kcalBySubCategory, foodBySubCategory),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listMealByCategory(context, subCategories, 'Meal Goal',
                          kcalBySubCategory, foodBySubCategory),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _titleRow(
                        context,
                        'Time Of Day',
                        subCategories,
                        'Meal Time',
                        kcalBySubCategory,
                        foodBySubCategory,
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listMealByCategory(context, subCategories, 'Meal Time',
                          kcalBySubCategory, foodBySubCategory),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _titleRow(context, 'Diet', subCategories, 'Meal Diet',
                          kcalBySubCategory, foodBySubCategory),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      _listMealByCategory(context, subCategories, 'Meal Diet',
                          kcalBySubCategory, foodBySubCategory),
                    ],
                  ),
                );
              }
              return Container();
            });
          }
          return Container();
        }));
  }

  Widget _listMealByCategory(
      BuildContext context,
      List<MealSubCategoryEntity> allSubcategory,
      String categoryName,
      Map<String, double> kcalBySubCategory,
      Map<String, int> foodBySubCategory) {
    final normalizedName = categoryName.toLowerCase().trim();
    final List<MealSubCategoryEntity> items = allSubcategory
        .where((e) =>
            e.category!.categoryName.toLowerCase().trim() == normalizedName)
        .toList();
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final subCategoryName = item.subCategoryName;
          final kcal = kcalBySubCategory[subCategoryName] ?? 0;
          final totalFood = foodBySubCategory[subCategoryName] ?? 0;
          return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: MealSubCategoryCardPlan(
                  subCategoryId: item.id,
                  subCategoryName: item.subCategoryName,
                  description: item.description,
                  kcal: kcal,
                  totalFood: totalFood));
        },
      ),
    );
  }

  Map<String, List<MealSubCategoryEntity>> groupSubCategoriesByCategoryList(
      List<MealSubCategoryEntity> allSubs) {
    final Map<String, List<MealSubCategoryEntity>> grouped = {};

    for (var sub in allSubs) {
      final category = sub.category?.categoryName;
      if (category != null) {
        final categoryName = sub.category!.categoryName;
        grouped.putIfAbsent(categoryName, () => []).add(sub);
      }
    }

    return grouped;
  }

  Widget _titleRow(
      BuildContext context,
      String title,
      List<MealSubCategoryEntity> subCategoryList,
      String categoryName,
      Map<String, double> kcalBySubCategory,
      Map<String, int> foodBySubCategory) {
    final filteredList = subCategoryList
        .where((e) =>
            e.category?.categoryName.toLowerCase().trim() ==
            categoryName.toLowerCase().trim())
        .toList();
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.primaryColor1,
              fontSize: AppFontSize.body(context),
              fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              AppNavigator.push(
                  context,
                  MealSubCategoryPlanListPage(
                      total: filteredList,
                      categoryName: categoryName,
                      kcal: kcalBySubCategory,
                      totalFood: foodBySubCategory));
            },
            child: Text(
              'See All',
              style: TextStyle(
                  color: AppColors.gray,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSize.caption(context)),
            ))
      ],
    );
  }
}

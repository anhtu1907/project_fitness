import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_sub_category_plan_list.dart';

class MealSearchByGoal extends StatelessWidget {
  const MealSearchByGoal({super.key});

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
      child: BlocBuilder<MealSubCategoryCubit, MealSubCategoryState>(
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
            final mealSubList = state.entity;
            Map<String, List<MealSubCategoryEntity>> groupedCategory = {};
            for (var category in mealSubList) {
              final categoryName = category.category!.categoryName;
              groupedCategory.putIfAbsent(categoryName, () => []).add(category);
            }
            return BlocBuilder<MealsCubit, MealsState>(
              builder: (context, state) {
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
                  final mealList = state.entity;
                  Map<String, List<MealsEntity>> groupedSubCategory = {};
                  for (var meal in mealList) {
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

                  List goals = ['Weight Loss', 'Muscle Gain', 'Maintenance'];
                  final imageGoal = [
                    'https://i.pinimg.com/736x/0c/67/e9/0c67e9f985bfcc211abd8191682e6a17.jpg',
                    'https://i.pinimg.com/736x/8d/41/ae/8d41ae7cc96788b4e297975cdff7ef01.jpg',
                    'https://i.pinimg.com/736x/13/d0/fb/13d0fbc9aa13f5e22b981ea4d2591048.jpg'
                  ];
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return GestureDetector(
                            onTap: () {
                              final filteredList = mealSubList
                                  .where((subCat) => subCat.subCategoryName == goal)
                                  .toList();
                              final filteredKcalBySubCategory = <String, double>{};
                              for (var subCat in filteredList) {
                                final subCatName = subCat.subCategoryName;
                                final meals = groupedSubCategory[subCatName] ?? [];
                                final kcal = meals.fold(0.0, (sum, item) => sum + item.kcal);
                                filteredKcalBySubCategory[subCatName] = kcal;
                              }

                              final filteredFoodBySubCategory = <String, int>{};
                              for (var subCat in filteredList) {
                                final subCatName = subCat.subCategoryName;
                                final meals = groupedSubCategory[subCatName] ?? [];
                                filteredFoodBySubCategory[subCatName] = meals.length;
                              }
                              if (filteredList.isNotEmpty) {
                                AppNavigator.push(
                                  context,
                                    MealSubCategoryPlanListPage(
                                    total: filteredList,
                                    categoryName: goal,
                                    kcal: filteredKcalBySubCategory,
                                    totalFood: filteredFoodBySubCategory)
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: media.width * 0.41,
                              height: media.height * 0.095,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xff3674B5).withOpacity(0.6),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        imageGoal[index % imageGoal.length],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // LỚP MỜ OVERLAY
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.fastfood,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.02,
                                        ),
                                        Text(
                                          goal,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  AppFontSize.body(context)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

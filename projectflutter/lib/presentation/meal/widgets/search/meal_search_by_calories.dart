import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_sub_category_plan_list.dart';

class MealSearchByCalories extends StatelessWidget {
  const MealSearchByCalories({super.key});

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
                  List calories = ['60-479 kcal', '480-900 kcal', '>900 kcal'];
                  final caloriesRanges = {
                    '60-479 kcal': [60, 479],
                    '480-900 kcal': [480, 900],
                    '>900 kcal': [901, 99999],
                  };
                  const colors = [
                    Color(0xFF81C784),
                    Color(0xFFFFA726),
                    Color(0xFFE53935),
                  ];

                  const imageCalories = [
                    'https://i.pinimg.com/736x/47/37/8e/47378ef7e2db696f7fc9e4a80264b886.jpg',
                    'https://i.pinimg.com/736x/af/1a/83/af1a83f25a7ec28ada610a357a4f9a25.jpg',
                    'https://i.pinimg.com/736x/90/0c/d0/900cd0b78ba0e0fc1ba2f8448eb0cf39.jpg'
                  ];
                  Map<String, List<MealsEntity>> groupedSubCategory = {};
                  for (var meal in mealList) {
                    for (var sub in meal.subCategory) {
                      final subCategoryName = sub.subCategoryName;
                      groupedSubCategory.putIfAbsent(subCategoryName, () => []).add(meal);
                    }
                  }
                  Map<String, double> kcalBySubCategory = {};
                  groupedSubCategory.forEach((subCatName, foods) {
                    kcalBySubCategory[subCatName] =
                        foods.fold(0, (sum, item) => sum += item.kcal);
                  });

                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: calories.length,
                      itemBuilder: (context, index) {
                        final calo = calories[index];
                        return GestureDetector(
                          onTap: () {
                            final range = caloriesRanges[calo]!;
                            final minCalo = range[0];
                            final maxCalo = range[1];
                            final filteredList = mealSubList.where((subCat) {
                              final subCatKcal =
                                  kcalBySubCategory[subCat.subCategoryName] ??
                                      0;
                              return subCatKcal >= minCalo &&
                                  subCatKcal <= maxCalo;
                            }).toList();
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
                            AppNavigator.push(
                                context,
                                MealSubCategoryPlanListPage(
                                    total: filteredList,
                                    categoryName: calo,
                                    kcal: filteredKcalBySubCategory,
                                    totalFood: filteredFoodBySubCategory));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: media.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: colors[index % colors.length]
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
                                        imageCalories[index % imageCalories.length],
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.restaurant,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.02,
                                        ),
                                        Text(
                                          calo,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: AppFontSize.body(context)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        );
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

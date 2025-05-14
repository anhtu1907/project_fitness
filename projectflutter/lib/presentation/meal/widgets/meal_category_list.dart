import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_category_item.dart';

class MealCategoryList extends StatelessWidget {
  const MealCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
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
            final subCategoryList = state.entity;
            Map<String, List<MealSubCategoryEntity>> groupedCategory = {};
            for (var category in subCategoryList) {
              final categoryName = category.category!.categoryName;
              groupedCategory.putIfAbsent(categoryName, () => []).add(category);
            }
            final groupedList = groupedCategory.entries.toList();
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
                  final foodList = state.entity;
                  Map<String, List<MealsEntity>> groupedSubCategory = {};
                  for (var food in foodList) {
                    final subCategoryName =
                        food.subCategory.subCategoryName.trim();
                    groupedSubCategory
                        .putIfAbsent(subCategoryName, () => [])
                        .add(food);
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

                  Map<String, List<MealsEntity>> mealsByCategory = {};
                  for(var entry in groupedList){
                    final subCategoryName = entry.key;
                    final subCategoreies = entry.value;
                    final meals = <MealsEntity>[];

                    for(var subCategory in subCategoreies){
                      final subCatName = subCategory.subCategoryName.trim();
                      final mealsForSubCat = groupedSubCategory[subCatName];
                      if(mealsForSubCat != null){
                        meals.addAll(mealsForSubCat);
                      }
                    }
                    mealsByCategory[subCategoryName] = meals;
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: groupedList.length,
                    itemBuilder: (context, index) {
                      final entry = groupedList[index];
                      return MealCategoryItem(
                        total: entry.value,
                        kcal: kcalBySubCategory,
                        totalFood: foodBySubCategory,
                      );
                    },
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

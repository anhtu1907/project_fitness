import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_sub_category_item.dart';

class MealTypeListSearch extends StatelessWidget {
  const MealTypeListSearch({super.key});

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
            List<String> subCategoryListChoice = ['Salad', 'Meat','Fruit','Dessert'];
            final imageMealTypes = [
              AppImages.vegetable,
              AppImages.meat,
              AppImages.fruit,
              AppImages.cake,
            ];
            final filteredSubCategories = subCategoryList
                .where((e) => subCategoryListChoice.contains(e.subCategoryName))
                .toList();
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
                    for (var sub in food.subCategory) {
                      final subCategoryName = sub.subCategoryName;
                      groupedSubCategory
                          .putIfAbsent(subCategoryName, () => [])
                          .add(food);
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
                    itemCount: filteredSubCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = filteredSubCategories[index];
                      return MealSubCategoryItem(
                      subCategoryId: subCategory.id,
                        image: imageMealTypes[index % imageMealTypes.length],
                        typeName: subCategory.subCategoryName
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

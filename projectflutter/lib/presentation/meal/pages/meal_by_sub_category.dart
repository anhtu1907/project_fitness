import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_grid_item.dart';

class MealBySubCategory extends StatelessWidget {
  final int subCategoryId;
  final String categoryName;
  const MealBySubCategory(
      {super.key, required this.subCategoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(categoryName),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: BlocProvider(
        create: (context) =>
            MealBySubCategoryCubit()..listMealBySubCategory(subCategoryId),
        child: BlocBuilder<MealBySubCategoryCubit, MealBySubCategoryState>(
          builder: (context, state) {
            if (state is MealBySubCategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoadMealBySubCategoryFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            if (state is MealBySubCategoryLoaded) {
              Map<String, List<MealsEntity>> groupedByTime = {};
              for (var meal in state.entity) {
                final timeOfDay = meal.timeOfDay.timeName;
                print('Time of Day : $timeOfDay');
                groupedByTime.putIfAbsent(timeOfDay, () => []).add(meal);
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: groupedByTime.entries.map((entry) {
                      return Column(
                        children: [
                          const SizedBox(height: 10,),
                          Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10,),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                              return MealGridItem(meal: entry.value[index]);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1),
                          ),
                        ],
                      );
                    }).toList(),
                  ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

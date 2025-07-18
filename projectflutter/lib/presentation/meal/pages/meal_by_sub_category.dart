import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
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
        title: Text(
          categoryName,
          style: TextStyle(
              fontSize: AppFontSize.titleAppBar(context),
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
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
                for (var time in meal.timeOfDay) {
                  groupedByTime.putIfAbsent(time.timeName, () => []).add(meal);
                }
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: groupedByTime.entries.map((entry) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(entry.key,
                              style: TextStyle(
                                  fontSize: AppFontSize.body(context),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                              final mealItem = MealGridItem(meal: entry.value[index]);
                              return entry.value.length == 1
                                  ? Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: mealItem,
                                ),
                              )
                                  : mealItem;
                            },
                            gridDelegate:
                                 SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:  entry.value.length == 1 ? 1 : 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                   childAspectRatio: entry.value.length == 1 ? 1.8 : 1,),
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

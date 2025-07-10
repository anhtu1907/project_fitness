import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_search_list.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_search_page.dart';

class MealSearchField extends StatefulWidget {
  const MealSearchField({super.key});

  @override
  State<MealSearchField> createState() => _MealSearchFieldState();
}

class _MealSearchFieldState extends State<MealSearchField> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealsCubit()..listMeal(),
      child: BlocBuilder<MealsCubit, MealsState>(
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
            final meals = state.entity;
            var media = MediaQuery.of(context).size;

            return GestureDetector(
              onTap: () {
                AppNavigator.push(
                  context,
                  MealSearchPage(mealList: meals),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    SizedBox(width: media.width * 0.02),
                    Text(
                      "Search by meal...",
                      style: TextStyle(
                        fontSize: AppFontSize.body(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

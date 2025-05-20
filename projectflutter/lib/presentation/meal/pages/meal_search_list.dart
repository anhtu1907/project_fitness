import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_search_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_search_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_grid_item.dart';

class MealSearchList extends StatelessWidget {
  final String mealName;
  const MealSearchList({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        title: Text('Search Results'),
      ),
      body: BlocProvider(
        create: (context) => MealBySearchCubit()..listMealBySearch(mealName),
        child: BlocBuilder<MealBySearchCubit, MealBySearchState>(
          builder: (context, state) {
            if (state is MealBySearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LoadMealBySearchFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }

            if (state is MealBySearchLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: state.entity.length,
                  itemBuilder: (context, index) {
                    return MealGridItem(meal: state.entity[index]);
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

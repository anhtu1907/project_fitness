import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_sub_category_cubit.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_sub_category_state.dart';
import 'package:projectflutter/presentation/meal/widgets/meal_category_grid.dart';

class MealBySubCategory extends StatelessWidget {
  final int subCategoryId;
  final String categoryName;
  const MealBySubCategory(
      {super.key, required this.subCategoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        titlte: Text(categoryName),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: state.entity.length,
                  itemBuilder: (context, index) {
                    return MealCategoryGrid(
                        index: index, meal: state.entity[index]);
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

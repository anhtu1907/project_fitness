
import 'package:projectflutter/domain/meal/entity/meals.dart';

abstract class MealBySubCategoryState {}

class MealBySubCategoryLoading extends MealBySubCategoryState {}

class MealBySubCategoryLoaded extends MealBySubCategoryState {
  List<MealsEntity> entity;
  MealBySubCategoryLoaded({required this.entity});
}

class LoadMealBySubCategoryFailure extends MealBySubCategoryState {
  final String errorMessage;
  LoadMealBySubCategoryFailure({required this.errorMessage});
}

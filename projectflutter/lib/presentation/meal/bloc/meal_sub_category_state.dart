import 'package:projectflutter/domain/meal/entity/meal_sub_category.dart';

abstract class MealSubCategoryState {}

class MealSubCategoryLoading extends MealSubCategoryState {}

class MealSubCategoryLoaded extends MealSubCategoryState {
  List<MealSubCategoryEntity> entity;
  MealSubCategoryLoaded({required this.entity});
}

class LoadMealSubCategoryFailure extends MealSubCategoryState {
  final String errorMessage;
  LoadMealSubCategoryFailure({required this.errorMessage});
}

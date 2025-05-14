import 'package:projectflutter/domain/meal/entity/meal_category.dart';

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<MealCategoryEntity> entity;

  CategoryLoaded({required this.entity});
}

class LoadCategoryFailure extends CategoryState {
  final String errorMessage;

  LoadCategoryFailure({required this.errorMessage});
}

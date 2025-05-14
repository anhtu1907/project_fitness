import 'package:projectflutter/domain/meal/entity/meals.dart';

abstract class MealBySearchState {}

class MealBySearchLoading extends MealBySearchState {}

class MealBySearchLoaded extends MealBySearchState {
  List<MealsEntity> entity;
  MealBySearchLoaded({required this.entity});
}

class LoadMealBySearchFailure extends MealBySearchState {
  final String errorMessage;
  LoadMealBySearchFailure({required this.errorMessage});
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:projectflutter/domain/meal/entity/meals.dart';

abstract class MealByIdState {}

class MealByIdLoaing extends MealByIdState {}

class MealByIdLoaded extends MealByIdState {
  MealsEntity entity;
  MealByIdLoaded({required this.entity});
}

class LoadMealFailure extends MealByIdState {
  final String errorMessage;
  LoadMealFailure({required this.errorMessage});
}

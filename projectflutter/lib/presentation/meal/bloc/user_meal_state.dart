import 'package:projectflutter/domain/meal/entity/user_meals.dart';

abstract class UserMealState {}

class UserMealLoading extends UserMealState {}

class UserMealLoaded extends UserMealState {
  List<UserMealsEntity> entity;
  UserMealLoaded({required this.entity});
}

class LoadUserMealFailure extends UserMealState {
  final String errorMessage;
  LoadUserMealFailure({required this.errorMessage});
}

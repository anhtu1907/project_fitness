// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:projectflutter/domain/meal/entity/meals.dart';

abstract class MealsState {}

class MealsLoaing extends MealsState {}

class MealsLoaded extends MealsState {
  List<MealsEntity> entity;
  MealsLoaded({
    required this.entity,
  });
}

class LoadMealsFailure extends MealsState {
  final String errorMessage;
  LoadMealsFailure({required this.errorMessage});
}

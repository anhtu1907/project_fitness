// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';

abstract class ExerciseUserState {}

class ExerciseUserLoading extends ExerciseUserState {}

class ExerciseUserLoaded extends ExerciseUserState {
  List<ExerciseUserEntity> entity;
  ExerciseUserLoaded({
    required this.entity,
  });
}

class LoadExerciseUserFailure extends ExerciseUserState {
  final String errorMessage;
  LoadExerciseUserFailure({required this.errorMessage});
}

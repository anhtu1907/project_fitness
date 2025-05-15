import 'package:projectflutter/domain/exercise/entity/exercise_schedule_entity.dart';

abstract class ExerciseScheduleState {}

class ExerciseScheduleLoading extends ExerciseScheduleState {}

class ExerciseScheduleLoaded extends ExerciseScheduleState {
  final List<ExerciseScheduleEntity> entity;
  ExerciseScheduleLoaded({required this.entity});
}

class LoadExerciseScheduleFailure extends ExerciseScheduleState {
  final String errorMessage;
  LoadExerciseScheduleFailure({required this.errorMessage});
}

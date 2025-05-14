// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:projectflutter/domain/exercise/entity/exercise_progress_entity.dart';

abstract class WorkoutProgressState {}

class WorkoutProgressLoading extends WorkoutProgressState {}

class WorkoutProgressLoaded extends WorkoutProgressState {
  List<ExerciseProgressEntity> listProgress;
  WorkoutProgressLoaded({
    required this.listProgress,
  });
}

class LoadWorkoutProgressFailure extends WorkoutProgressState {
  final String errorMessage;

  LoadWorkoutProgressFailure({required this.errorMessage});
}

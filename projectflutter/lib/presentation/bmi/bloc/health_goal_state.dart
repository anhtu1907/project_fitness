import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';

abstract class HealthGoalState{}

class HealthGoalLoading extends HealthGoalState {}

class HealthGoalLoaded extends HealthGoalState {
  final List<BmiGoalEntity> goal;
  HealthGoalLoaded({required this.goal});
}

class LoadedHealthGoalFailure extends HealthGoalState {
  final String errorMessage;
  LoadedHealthGoalFailure({required this.errorMessage});
}
abstract class CheckBmiGoalState {}

class BmiGoalLoading extends CheckBmiGoalState {}

class BmiGoalExists extends CheckBmiGoalState {}

class BmiGoalNotExists extends CheckBmiGoalState {}

class BmiGoalError extends CheckBmiGoalState {
  final String errorMessage;
  BmiGoalError({required this.errorMessage});
}

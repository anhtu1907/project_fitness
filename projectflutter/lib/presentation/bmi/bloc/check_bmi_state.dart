abstract class CheckBmiState {}

class BmiLoading extends CheckBmiState {}

class BmiExists extends CheckBmiState {}

class BmiNotExists extends CheckBmiState {}

class BmiError extends CheckBmiState {
  final String errorMessage;
  BmiError({required this.errorMessage});
}

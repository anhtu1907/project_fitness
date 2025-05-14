abstract class ShowBmiState {}

class BmiLoading extends ShowBmiState {}

class BmiLoaded extends ShowBmiState {
  final double bmi;
  BmiLoaded({required this.bmi});
}

class LoadedBmiFailure extends ShowBmiState {
  final String errorMessage;
  LoadedBmiFailure({required this.errorMessage});
}

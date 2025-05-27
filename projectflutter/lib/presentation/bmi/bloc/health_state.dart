import 'package:projectflutter/domain/bmi/entity/bmi.dart';

abstract class HealthState {}

class HealthLoading extends HealthState {}

class HealthLoaded extends HealthState {
  final List<BmiEntity> bmi;
  HealthLoaded({required this.bmi});
}

class LoadedHealthFailure extends HealthState {
  final String errorMessage;
  LoadedHealthFailure({required this.errorMessage});
}

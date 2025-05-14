import 'package:projectflutter/domain/run/entity/run_entity.dart';

abstract class RunRecordState {}

class RunRecordLoading extends RunRecordState {}

class RunRecordLoaded extends RunRecordState {
  List<RunEntity> listRun;
  RunRecordLoaded({required this.listRun});
}

class LoadRunRecordFailure extends RunRecordState {
  final String errorMessage;
  LoadRunRecordFailure({required this.errorMessage});
}

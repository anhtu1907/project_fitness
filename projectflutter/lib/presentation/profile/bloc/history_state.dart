// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';

abstract class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  List<ExerciseUserEntity> listHistory;
  HistoryLoaded({
    required this.listHistory,
  });
}

class LoadHistoryFailure extends HistoryState {
  final String errorMessage;

  LoadHistoryFailure({required this.errorMessage});
}

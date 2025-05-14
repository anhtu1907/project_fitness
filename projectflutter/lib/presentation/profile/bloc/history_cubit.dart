import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_user_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_result.dart';
import 'package:projectflutter/presentation/profile/bloc/history_state.dart';
import 'package:projectflutter/service_locator.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading());

  List<ExerciseUserEntity> _allResult = [];
  void displayHistory() async {
    var result = await sl<GetExerciseResultUseCase>().call();
    result.fold((err) {
      emit(LoadHistoryFailure(errorMessage: err));
    }, (data) {
      _allResult = data;
      final today = DateTime.now();
      filterExerciseResultByDate(today);
    });
  }

  void filterExerciseResultByDate(DateTime selectedDate) {
    final filteredExercises = _allResult.where((exercise) {
      return exercise.createdAt!.year == selectedDate.year &&
          exercise.createdAt!.month == selectedDate.month &&
          exercise.createdAt!.day == selectedDate.day;
    }).toList();
    emit(HistoryLoaded(listHistory: filteredExercises));
  }
}

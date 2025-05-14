import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_by_id.dart';

import 'package:projectflutter/domain/exercise/usecase/get_exercises.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExercisesCubit extends Cubit<ExercisesState> {
  ExercisesCubit() : super(ExercisesLoading());

  Future<void> listExercise() async {
    final result = await sl<GetExercisesUseCase>().call();
    result.fold((err) {
      emit(LoadExercisesFailure(errorMessage: err));
    }, (data) {
      emit(ExercisesLoaded(entity: data));
    });
  }

  void exerciseById(int exerciseId) async {
    var result = await sl<GetExerciseByIdUseCase>().call(params: exerciseId);
    result.fold((err) {
      emit(LoadExercisesFailure(errorMessage: err));
    }, (data) {
      emit(ExercisesLoaded(entity: data));
    });
  }
}

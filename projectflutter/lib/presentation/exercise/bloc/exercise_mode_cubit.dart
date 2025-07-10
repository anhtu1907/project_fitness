import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_mode.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_mode_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseModeCubit extends Cubit<ExerciseModeState> {
  ExerciseModeCubit() : super(ExerciseModeLoading());

  void listExerciseMode() async {
    var result = await sl<GetExerciseModeUseCase>().call();

    result.fold((err) {
      emit(LoadExerciseModeFailure(errorMessage: err));
    }, (data) {
      emit(ExerciseModeLoaded(entity: data));
    });
  }
}

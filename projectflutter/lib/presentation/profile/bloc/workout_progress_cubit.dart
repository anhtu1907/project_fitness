import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_progress.dart';
import 'package:projectflutter/presentation/profile/bloc/workout_progress_state.dart';
import 'package:projectflutter/service_locator.dart';

class WorkoutProgressCubit extends Cubit<WorkoutProgressState> {
  WorkoutProgressCubit() : super(WorkoutProgressLoading());

  void displayProgress() async {
    var result = await sl<GetExerciseProgressUseCase>().call();
    result.fold((err) {
      emit(LoadWorkoutProgressFailure(errorMessage: err));
    }, (data) {
      emit(WorkoutProgressLoaded(listProgress: data));
    });
  }
}

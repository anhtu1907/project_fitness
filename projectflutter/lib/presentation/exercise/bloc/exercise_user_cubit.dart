import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_result.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_user_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseUserCubit extends Cubit<ExerciseUserState> {
  ExerciseUserCubit() : super(ExerciseUserLoading());

  void resultUser() async {
    final result = await sl<GetExerciseResultUseCase>().call();
    result.fold((err) {
      emit(LoadExerciseUserFailure(errorMessage: err));
    }, (data) {
      emit(ExerciseUserLoaded(entity: data));
    });
  }
}

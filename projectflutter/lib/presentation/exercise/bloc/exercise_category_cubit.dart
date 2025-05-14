import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_category.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseCategoryCubit extends Cubit<ExerciseCategoryState> {
  ExerciseCategoryCubit() : super(ExerciseCategoryLoading());

  void listCategory() async {
    var result = await sl<GetExerciseCategoryUseCase>().call();

    result.fold((err) {
      emit(LoadExerciseCategoryFailure(errorMessage: err));
    }, (data) {
      emit(ExerciseCategoryLoaded(entity: data));
    });
  }
}

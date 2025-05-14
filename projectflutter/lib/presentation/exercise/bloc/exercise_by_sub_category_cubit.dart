import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_by_sub_category.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_by_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseBySubCategoryCubit extends Cubit<ExerciseBySubCategoryState> {
  ExerciseBySubCategoryCubit() : super(ExerciseBySubCategoryLoading());

  void listExerciseBySubCategoryId(int subCategoryId) async {
    var result =
        await sl<GetExerciseBySubCategoryUseCase>().call(params: subCategoryId);
    result.fold((err) {
      emit(LoadExerciseBySubCategoryFailure(errorMessage: err));
    }, (data) {
      emit(ExerciseBySubCategoryLoaded(entity: data));
    });
  }
}

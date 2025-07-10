import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_list_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseListSubCategoryCubit extends Cubit<ExerciseListSubCategoryState> {
  ExerciseListSubCategoryCubit() : super(ListSubCategoryLoading());

  void listExerciseBySubCategoryName(String subCategoryName) async {
    var result =
    await sl<SearchBySubCategoryNameUseCase>().call(params: subCategoryName);
    result.fold((err) {
      emit(LoadListSubCategoryFailure(errorMessage: err));
    }, (data) {
      emit(ListSubCategoryLoaded(entity: data));
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_sub_category.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseSubCategoryCubit extends Cubit<ExerciseSubCategoryState> {
  ExerciseSubCategoryCubit() : super(SubCategoryLoading());

  Future<void> listSubCategory() async {
    final result = await sl<GetExerciseSubCategoryUseCase>().call();
    result.fold((err) {
      emit(LoadSubCategoryFailure(errorMessage: err));
    }, (data) {
      emit(SubCategoryLoaded(entity: data));
    });
  }
}

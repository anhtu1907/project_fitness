import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/exercise/usecase/get_exercise_sub_category.dart';
import 'package:projectflutter/domain/exercise/usecase/get_sub_category_program.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseSubCategoryProgramCubit extends Cubit<ExerciseSubCategoryProgramState> {
  ExerciseSubCategoryProgramCubit() : super(SubCategoryProgramLoading());

  Future<void> listSubCategoryProgram() async {
    final result = await sl<GetSubCategoryProgramUseCase>().call();
    result.fold((err) {
      emit(LoadSubCategoryProgramFailure(errorMessage: err));
    }, (data) {
      emit(SubCategoryProgramLoaded(entity: data));
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_sub_category.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class MealBySubCategoryCubit extends Cubit<MealBySubCategoryState> {
  MealBySubCategoryCubit() : super(MealBySubCategoryLoading());

  void listMealBySubCategory(int subCategoryId) async {
    var result =
        await sl<GetMealBySubCategoryUseCase>().call(params: subCategoryId);
    result.fold((err) {
      emit(LoadMealBySubCategoryFailure(errorMessage: err));
    }, (data) {
      emit(MealBySubCategoryLoaded(entity: data));
    });
  }
}

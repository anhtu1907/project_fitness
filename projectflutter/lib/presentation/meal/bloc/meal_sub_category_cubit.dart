import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_sub_category.dart';

import 'package:projectflutter/presentation/meal/bloc/meal_sub_category_state.dart';
import 'package:projectflutter/service_locator.dart';

class MealSubCategoryCubit extends Cubit<MealSubCategoryState> {
  MealSubCategoryCubit() : super(MealSubCategoryLoading());

  Future<void> listSubCategory() async {
    final result = await sl<GetAllSubCategoryUseCase>().call();
    result.fold((err) {
      emit(LoadMealSubCategoryFailure(errorMessage: err));
    }, (data) {
      emit(MealSubCategoryLoaded(entity: data));
    });
  }
}

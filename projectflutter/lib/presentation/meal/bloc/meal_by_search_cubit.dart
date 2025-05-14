import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/search_by_meal_name.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_search_state.dart';
import 'package:projectflutter/service_locator.dart';

class MealBySearchCubit extends Cubit<MealBySearchState> {
  MealBySearchCubit() : super(MealBySearchLoading());

  void listMealBySearch(String mealName) async {
    var result = await sl<SearchByMealNameUseCase>().call(params: mealName);
    result.fold((err) {
      emit(LoadMealBySearchFailure(errorMessage: err));
    }, (data) {
      emit(MealBySearchLoaded(entity: data));
    });
  }
}

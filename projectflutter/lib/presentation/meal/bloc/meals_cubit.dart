import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_meal.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_id.dart';
import 'package:projectflutter/presentation/meal/bloc/meals_state.dart';
import 'package:projectflutter/service_locator.dart';

class MealsCubit extends Cubit<MealsState> {
  MealsCubit() : super(MealsLoaing());

  Future<void> listMeal() async {
    final result = await sl<GetAllMealUseCase>().call();
    result.fold((err) {
      emit(LoadMealsFailure(errorMessage: err));
    }, (data) {
      emit(MealsLoaded(entity: data));
    });
  }

  void mealById(int mealId) async {
    var result = await sl<GetMealById>().call(params: mealId);
    result.fold((err) {
      emit(LoadMealsFailure(errorMessage: err));
    }, (data) {
      emit(MealsLoaded(entity: data));
    });
  }
}

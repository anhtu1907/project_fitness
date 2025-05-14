import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/usecase/get_meal_by_id.dart';
import 'package:projectflutter/domain/meal/usecase/save_record_meal.dart';
import 'package:projectflutter/presentation/meal/bloc/meal_by_id_state.dart';
import 'package:projectflutter/service_locator.dart';

class MealByIdCubit extends Cubit<MealByIdState> {
  MealByIdCubit() : super(MealByIdLoaing());

  void mealById(int mealId) async {
    var result = await sl<GetMealById>().call(params: mealId);
    result.fold((err) {
      emit(LoadMealFailure(errorMessage: err));
    }, (data) {
      emit(MealByIdLoaded(entity: data));
    });
  }

  void saveRecordMeal(List<int> mealId) async {
    await sl<SaveRecordMealUseCase>().call(params: mealId);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/meal/entity/user_meals.dart';
import 'package:projectflutter/domain/meal/usecase/get_all_record_meal.dart';
import 'package:projectflutter/presentation/meal/bloc/user_meal_state.dart';
import 'package:projectflutter/service_locator.dart';

class UserMealCubit extends Cubit<UserMealState> {
  UserMealCubit() : super(UserMealLoading());
  List<UserMealsEntity> _allMeals = [];
  void displayRecord() async {
    var result = await sl<GetAllRecordMealUseCase>().call();
    result.fold((err) {
      emit(LoadUserMealFailure(errorMessage: err));
    }, (data) {
      _allMeals = data;
      final today = DateTime.now();
      filterMealsByDate(today);
    });
  }

  void listRecord() async {
    var result = await sl<GetAllRecordMealUseCase>().call();
    result.fold((err) {
      emit(LoadUserMealFailure(errorMessage: err));
    }, (data) {
      emit(UserMealLoaded(entity: data));
    });
  }

  void filterMealsByDate(DateTime selectedDate) {
    final filteredMeals = _allMeals.where((meal) {
      return meal.createdAt!.year == selectedDate.year &&
          meal.createdAt!.month == selectedDate.month &&
          meal.createdAt!.day == selectedDate.day;
    }).toList();
    emit(UserMealLoaded(entity: filteredMeals));
  }
}

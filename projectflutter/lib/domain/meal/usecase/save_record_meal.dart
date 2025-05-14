import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SaveRecordMealUseCase extends UseCase<Either, List<int>> {
  @override
  Future<Either> call({List<int> ? params}) async {
    return await sl<MealRepository>().saveRecordMeal(params!);
  }
}

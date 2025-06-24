import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class NoParamsRecord {}

class DeleteAllRecordMealUseCase extends UseCase<void, DateTime> {
  @override
  Future<void> call({DateTime ? params}) async {
    return await sl<MealRepository>().deteleAllRecordMeal(params!);
  }
}

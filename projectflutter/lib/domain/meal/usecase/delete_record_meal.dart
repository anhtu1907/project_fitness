import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class DeleteRecordMealUseCase extends UseCase<void, int> {
  @override
  Future<void> call({int? params}) async {
    return await sl<MealRepository>().deteleRecordMeal(params!);
  }
}

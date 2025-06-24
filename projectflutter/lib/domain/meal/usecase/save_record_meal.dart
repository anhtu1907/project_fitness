import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/meal/request/user_meal_request.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SaveRecordMealUseCase extends UseCase<Either,UserMealRequest> {
  @override
  Future<Either> call({UserMealRequest ? params}) async {
    return await sl<MealRepository>().saveRecordMeal(params!);
  }
}

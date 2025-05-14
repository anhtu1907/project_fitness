import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/meal/repository/meal_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SearchByMealNameUseCase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<MealRepository>().searchByMealName(params!);
  }
}

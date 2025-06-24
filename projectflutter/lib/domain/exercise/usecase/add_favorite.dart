import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
class AddFavoriteUsecase extends UseCase<Either, String>{
  @override
  Future<Either> call({String? params}) async {
    return await sl<ExerciseRepository>().addNewFavoriteByUserId(params!);
  }
}
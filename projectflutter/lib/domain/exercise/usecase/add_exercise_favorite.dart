import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/exercise/request/exercise_favorite_request.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
class AddExerciseFavoriteUseCase extends UseCase<Either, ExerciseFavoriteRequest>{
  @override
  Future<Either> call({ExerciseFavoriteRequest ? params}) async {
    return await sl<ExerciseRepository>().addExerciseFavoriteByUserId(params!);
  }
}
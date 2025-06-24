import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
class GetExerciseFavoriteUseCase extends UseCase<Either,dynamic>{
  @override
  Future<Either> call({params}) async {
    return await sl<ExerciseRepository>().getAllExerciseFavorite(params);
  }
}
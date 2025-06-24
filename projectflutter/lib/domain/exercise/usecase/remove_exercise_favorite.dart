import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
class RemoveExerciseFavoriteUseCase extends UseCase<void, int>{
  @override
  Future<void> call({int? params}) async {
    return await sl<ExerciseRepository>().removeExerciseFavorite(params!);
  }
}
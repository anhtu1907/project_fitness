import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';
class GetSessionResetBatchUseCase extends UseCase<int, int>{
  @override
  Future<int> call({int ? params}) async {
    return await sl<ExerciseRepository>().getResetBatchBySubCategory(params!) ?? 0;
  }
}
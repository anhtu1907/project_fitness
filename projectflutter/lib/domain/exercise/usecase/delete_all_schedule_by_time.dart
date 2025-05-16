import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';

class NoParams {}

class DeleteAllScheduleByTimeUseCase extends UseCase<void, NoParams> {
  @override
  Future<void> call({void params}) async {
    return await sl<ExerciseRepository>().deleteAllExerciseScheduleByTime();
  }
}

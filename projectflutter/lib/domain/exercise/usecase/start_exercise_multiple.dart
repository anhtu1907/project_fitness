import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_batch_request.dart';
import 'package:projectflutter/data/exercise/request/exercise_session_request.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';

class StartExerciseUseCase extends UseCase<Either, ExerciseSessionBatchRequest> {
  @override
  Future<Either> call({ExerciseSessionBatchRequest? params}) async {
    return await sl<ExerciseRepository>().startMultipleExercises(params!);
  }
}

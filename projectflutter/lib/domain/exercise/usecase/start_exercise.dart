import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/exercise/model/exercise_session_request.dart';
import 'package:projectflutter/domain/exercise/repository/exercise_repository.dart';
import 'package:projectflutter/service_locator.dart';

class StartExerciseUseCase extends UseCase<Either, ExerciseSessionRequest> {
  @override
  Future<Either> call({ExerciseSessionRequest? params}) async {
    return await sl<ExerciseRepository>().startExercise(params!);
  }
}

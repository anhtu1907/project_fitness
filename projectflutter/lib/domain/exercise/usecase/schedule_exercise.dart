import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/exercise/request/exercise_schedule_request.dart';
import 'package:projectflutter/data/exercise/source/exercise_service.dart';
import 'package:projectflutter/service_locator.dart';

class ScheduleExerciseUseCase extends UseCase<Either, ExerciseScheduleRequest> {
  @override
  Future<Either> call({ExerciseScheduleRequest? params}) async {
    return await sl<ExerciseService>().scheduleExercise(params!);
  }
}

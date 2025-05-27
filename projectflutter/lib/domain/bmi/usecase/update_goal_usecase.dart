import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class UpdateGoalUsecase extends UseCase<Either, double> {
  @override
  Future<Either> call({double? params}) async {
    return await sl<BmiRepository>().updateGoal(params!);
  }
}

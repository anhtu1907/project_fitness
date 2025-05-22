import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/service_locator.dart';

class GetTargetGoalUsecase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<BmiRepository>().getGoalByUserId();
  }
}

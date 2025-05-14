import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/run/repository/run_repository.dart';
import 'package:projectflutter/service_locator.dart';

class GetRecordRunByUserUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<RunRepository>().getRecordRunByUserId();
  }
}

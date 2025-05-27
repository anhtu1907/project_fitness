import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class GetAllDataByUserUseCase extends UseCase<Either,dynamic>{
  @override
  Future<Either> call({params}) async {
    return await sl<BmiRepository>().getAllDataByUserId();
  }
}
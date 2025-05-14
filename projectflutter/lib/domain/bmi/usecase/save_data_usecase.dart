import 'package:dartz/dartz.dart';
import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class SaveDataUsecase extends UseCase<Either, BmiRequest> {
  @override
  Future<Either> call({BmiRequest? params}) async {
    return await sl<BmiRepository>().saveData(params!);
  }
}

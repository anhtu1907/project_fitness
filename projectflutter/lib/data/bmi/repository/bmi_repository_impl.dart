import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';
import 'package:projectflutter/data/bmi/source/bmi_service.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class BmiRepositoryImpl extends BmiRepository {
  @override
  Future<Either> saveData(BmiRequest model) async {
    return await sl<BmiService>().saveData(model);
  }

  @override
  Future<bool> checkBmi() async {
    return await sl<BmiService>().checkBmi();
  }
}

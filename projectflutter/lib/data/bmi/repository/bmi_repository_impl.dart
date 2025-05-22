import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';
import 'package:projectflutter/data/bmi/source/bmi_service.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class BmiRepositoryImpl extends BmiRepository {
  @override
  Future<Either> saveData(BmiRequest model) async {
    return await sl<BmiService>().saveData(model);
  }

  @override
  Future<Either> updateData(double weight) async {
    return await sl<BmiService>().updateData(weight);
  }

  @override
  Future<Either> saveGoal(double targetWeight) async {
    return await sl<BmiService>().saveGoal(targetWeight);
  }

  @override
  Future<Either> updateGoal(double targetWeight) async {
    return await sl<BmiService>().updateGoal(targetWeight);
  }

  @override
  Future<bool> checkBmi() async {
    return await sl<BmiService>().checkBmi();
  }

  @override
  Future<bool> checkBmiGoal() async {
    return await sl<BmiService>().checkBmiGoal();
  }
}

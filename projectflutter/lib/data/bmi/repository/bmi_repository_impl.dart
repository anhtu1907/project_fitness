import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/model/bmi.dart';
import 'package:projectflutter/data/bmi/model/bmi_goal.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';
import 'package:projectflutter/data/bmi/source/bmi_service.dart';
import 'package:projectflutter/domain/bmi/entity/bmi.dart';
import 'package:projectflutter/domain/bmi/entity/bmi_goal.dart';
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

  @override
  Future<Either> getAllDataByUserId() async {
    final result = await sl<BmiService>().getAllDataByUserId();

    if (result.isLeft()) {
      return Left(result.swap().getOrElse(() => 'Unknown error'));
    }

    final data = result.getOrElse(() => []);
    try {
      List<BmiModel> models = (data as List)
          .map((e) => BmiModel.fromMap(e))
          .toList();
      List<BmiEntity> entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left('Mapping error: $e');
    }
  }

  @override
  Future<Either> getAllGoalByUserId() async {
    final result = await sl<BmiService>().getAllGoalByUserId();

    if (result.isLeft()) {
      return Left(result.swap().getOrElse(() => 'Unknown error'));
    }

    final data = result.getOrElse(() => []);
    try {
      List<BmiGoalModel> models = (data as List).map((e) =>
          BmiGoalModel.fromMap(e)).toList();
      List<BmiGoalEntity> entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left('Mapping error: $e');
    }
  }
}

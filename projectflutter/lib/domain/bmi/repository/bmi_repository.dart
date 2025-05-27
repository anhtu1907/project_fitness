import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';

abstract class BmiRepository {
  Future<Either> saveData(BmiRequest model);
  Future<Either> updateData(double weight);
  Future<Either> saveGoal(double targetWeight);
  Future<Either> updateGoal(double targetWeight);
  Future<Either> getAllDataByUserId();
  Future<Either> getAllGoalByUserId();
  Future<bool> checkBmi();
  Future<bool> checkBmiGoal();
}

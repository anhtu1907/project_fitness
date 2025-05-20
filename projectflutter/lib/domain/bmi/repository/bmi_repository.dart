import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';

abstract class BmiRepository {
  Future<Either> saveData(BmiRequest model);
  Future<Either> updateData(int weight);
  Future<Either> saveGoal(int targetWeight);
  Future<Either> updateGoal(int targetWeight);
  Future<bool> checkBmi();
}

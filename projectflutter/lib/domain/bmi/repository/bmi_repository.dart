import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';

abstract class BmiRepository {
  Future<Either> saveData(BmiRequest model);
  Future<bool> checkBmi();
}

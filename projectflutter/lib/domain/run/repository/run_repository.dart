import 'package:dartz/dartz.dart';

abstract class RunRepository {
  Future<void> stratTracking();
  Future<void> stopTracking();
  Future<Either> getRecordRunByUserId();
}

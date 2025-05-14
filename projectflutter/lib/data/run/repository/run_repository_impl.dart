import 'package:dartz/dartz.dart';
import 'package:projectflutter/data/run/model/run_model.dart';
import 'package:projectflutter/data/run/source/run_service.dart';
import 'package:projectflutter/domain/run/entity/run_entity.dart';
import 'package:projectflutter/domain/run/repository/run_repository.dart';
import 'package:projectflutter/service_locator.dart';

class RunRepositoryImpl extends RunRepository {
  @override
  Future<void> stratTracking() async {
    // TODO: implement stratTracking
    throw UnimplementedError();
  }

  @override
  Future<void> stopTracking() async {
    // TODO: implement stopTracking
    throw UnimplementedError();
  }

  @override
  Future<Either> getRecordRunByUserId() async {
    var runRecord = await sl<RunService>().getRecordRunByUserId();
    return runRecord.fold((err) {
      return Left(err);
    }, (data) async {
      List<RunModel> models =
          (data as List).map((e) => RunModel.fromMap(e)).toList();
      List<RunEntity> entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    });
  }
}

import 'package:projectflutter/core/usecase/usecase.dart';
import 'package:projectflutter/domain/bmi/repository/bmi_repository.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiGoalUsecase extends UseCase<bool, dynamic> {
  @override
  Future<bool> call({params}) async {
    return await sl<BmiRepository>().checkBmiGoal();
  }
}

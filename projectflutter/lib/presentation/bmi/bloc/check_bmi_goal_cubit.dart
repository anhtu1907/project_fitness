import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_goal_state.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiGoalCubit extends Cubit<CheckBmiGoalState> {
  CheckBmiGoalCubit() : super(BmiGoalLoading());

  void checkBmiGoal() async {
    emit(BmiGoalLoading());
    final result = await sl<GetTargetGoalUsecase>().call();
    result.fold((err) {
      emit(BmiGoalError(errorMessage: err));
    }, (data) async {
      final goalExist = await sl<CheckBmiGoalUsecase>().call();
      if (goalExist) {
        emit(BmiGoalExists());
      } else {
        emit(BmiGoalNotExists());
      }
    });
  }
}

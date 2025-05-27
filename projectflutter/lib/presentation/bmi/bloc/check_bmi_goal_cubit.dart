import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_goal_state.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiGoalCubit extends Cubit<CheckBmiGoalState> {
  CheckBmiGoalCubit() : super(BmiGoalLoading());

  void checkBmiGoal() async {
    emit(BmiGoalLoading());
    try {
      final getData = await sl<GetAllGoalByUserUseCase>().call();

      getData.fold(
            (l) {
          print('Get Data Left: $l');
          emit(BmiGoalNotExists());
        },
            (r) {
          if (r.isEmpty) {
            print('Get Data: empty list');
            emit(BmiGoalNotExists());
          } else {
            print('Get Data: has data');
            emit(BmiGoalExists());
          }
        },
      );
    } catch (error) {
      emit(BmiGoalError(errorMessage: error.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/check_bmi_usecase.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_state.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiCubit extends Cubit<CheckBmiState> {
  CheckBmiCubit() : super(BmiLoading());

  void checkBmi() async {
    emit(BmiLoading());
    try {
      final isExist = await sl<CheckBmiUsecase>().call();
      if (isExist) {
        emit(BmiExists());
      } else {
        emit(BmiNotExists());
      }
    } catch (error) {
      emit(BmiError(errorMessage: error.toString()));
    }
  }
}

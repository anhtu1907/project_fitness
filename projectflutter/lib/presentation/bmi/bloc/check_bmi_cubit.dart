
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/get_all_data_by_user.dart';

import 'package:projectflutter/presentation/bmi/bloc/check_bmi_state.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiCubit extends Cubit<CheckBmiState> {
  CheckBmiCubit() : super(BmiLoading());

  void checkBmi() async {
    emit(BmiLoading());
    print("Start checkBmi...");
    try {
      final getData = await sl<GetAllDataByUserUseCase>().call();
      print("getData completed: $getData");
      getData.fold(
            (l) {
          print("Fold left: $l");
          emit(BmiNotExists());
        },
            (r) {
          print("Fold right: $r");
          if (r.isEmpty) {
            emit(BmiNotExists());
          } else {
            emit(BmiExists());
          }
        },
      );
    } catch (error) {
      print("Catch error: $error");
      emit(BmiError(errorMessage: error.toString()));
    }
  }

}

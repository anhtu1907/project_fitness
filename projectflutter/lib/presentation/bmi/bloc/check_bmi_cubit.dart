import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/check_bmi_usecase.dart';
import 'package:projectflutter/domain/bmi/usecase/get_all_data_by_user.dart';

import 'package:projectflutter/presentation/bmi/bloc/check_bmi_state.dart';
import 'package:projectflutter/service_locator.dart';

class CheckBmiCubit extends Cubit<CheckBmiState> {
  CheckBmiCubit() : super(BmiLoading());

  void checkBmi() async {
    emit(BmiLoading());
    try {
      final getData = await sl<GetAllDataByUserUseCase>().call();
      getData.fold(
              (l) {
            print('Get Data Left: $l');
            emit(BmiNotExists());
          },
              (r) {
            if (r.isEmpty) {
              print('Get Data: empty list');
              emit(BmiNotExists());
            } else {
              print('Get Data: has data');
              emit(BmiExists());
            }
          }
      );
    } catch (error) {
      emit(BmiError(errorMessage: error.toString()));
    }
  }
}

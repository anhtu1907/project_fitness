import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/export.dart';
import 'package:projectflutter/presentation/bmi/bloc/bmi_goal_state.dart';
import 'package:projectflutter/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiGoalCubit extends Cubit<BmiGoalState> {
  BmiGoalCubit() : super(BmiGoalState());

  void selectedOption(String option) {
    emit(state.copyWith(selectedOption: option, error: null));
  }

  void updateWeight(String weight) {
    emit(state.copyWith(weight: weight, error: null));
  }

  Future<void> saveGoal() async {
    final doubleWeight = double.tryParse(state.weight);
    if (state.selectedOption == null) {
      emit(state.copyWith(error: 'Please select your goal'));
      return;
    }
    if (doubleWeight == null) {
      emit(state.copyWith(error: 'Please try input target weight of field'));
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final bmiJson =
        prefs.getString('bmi_latest') ?? prefs.getString('bmi_exist');
    if (bmiJson == null) {
      emit(state.copyWith(error: 'BMI data not found'));
      return;
    }
    final bmiData = jsonDecode(bmiJson);
    final dynamic bmi = bmiData['bmi'];
    if (bmi == null) {
      emit(state.copyWith(error: 'Nou found BMI data'));
      return;
    }
    final weightValue = bmi['weight'];
    final currentWeight = weightValue is num
        ? weightValue.toDouble()
        : double.tryParse(weightValue.toString());
    if (currentWeight == null) {
      emit(state.copyWith(error: 'Weight data not found'));
      return;
    }

    final option = state.selectedOption!;
    final bool isValid = switch (option) {
      'Muscle Gain' => doubleWeight > currentWeight,
      'Weight Loss' => doubleWeight < currentWeight,
      'Maintance' => doubleWeight >= currentWeight,
      _ => false
    };

    if (!isValid) {
      String message = switch (option) {
        'Muscle Gain' => 'Target weight greater than current weight',
        'Weight Loss' => 'Target weight less than current weight',
        'Maintance' => 'Target weight greater or equal than current weight',
        _ => 'Weight not is valid'
      };
      emit(state.copyWith(error: message));
      return;
    }

    final result = await sl<SaveGoalUsecase>().call(params: doubleWeight);
    result.fold(
      (error) => emit(state.copyWith(error: error.toString())),
      (success) {
        emit(state.copyWith(error: null));
      },
    );
  }
}

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
    final errorMessage = await validateAll();
    if (errorMessage != null) {
      emit(state.copyWith(error: errorMessage));
      return;
    }

    final doubleWeight = double.parse(state.weight);
    final result = await sl<SaveGoalUsecase>().call(params: doubleWeight);
    result.fold(
      (error) => emit(state.copyWith(error: error.toString())),
      (success) {
        emit(state.copyWith(error: null));
      },
    );
  }

  Future<String?> validateAll() async {
    final doubleWeight = double.tryParse(state.weight);
    if (state.selectedOption == null) {
      return 'Please select your goal';
    }
    if (doubleWeight == null) {
      return 'Please try input target weight of field';
    }
    final prefs = await SharedPreferences.getInstance();
    final bmiJson =
        prefs.getString('bmi_latest') ?? prefs.getString('bmi_exist');
    if (bmiJson == null) {
      return 'BMI data not found';
    }
    final bmiData = jsonDecode(bmiJson);

    // Kiểm tra kiểu của bmi
    double? currentWeight;
    if (bmiData is Map && bmiData.containsKey('weight')) {
      currentWeight = (bmiData['weight'] as num).toDouble();
    } else if (bmiData is num) {
      currentWeight = bmiData.toDouble();
    } else {
      return 'BMI data format is not recognized';
    }
    if (currentWeight == null) {
      return 'Weight data not found';
    }
    print('Current Weight : $currentWeight');
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
      return message;
    }

    return null;
  }

  void setError(String? error) {
    emit(state.copyWith(error: error));
  }
}
